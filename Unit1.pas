unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils,
  Vcl.Menus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Comp.UI, Data.Win.ADODB, StrUtils, Math, System.Generics.Collections,
  Clipbrd;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    ImageDetails1: TMenuItem;
    ImageDetails2: TMenuItem;
    ImageDetailsbdCyrillic1: TMenuItem;
    ImageDetailsbdCyrillic2: TMenuItem;
    ChangePassword1: TMenuItem;
    ChangePassword2: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    OpenFile1: TMenuItem;
    OpenFile2: TMenuItem;
    OpenFile3: TMenuItem;
    Label3: TLabel;
    Button3: TButton;
    Memo1: TMemo;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    Button5: TButton;
    Button6: TButton;
    PopupMenu1: TPopupMenu;
    WriteQuery1: TMenuItem;
    SelectQueryImageDetailsTemp1: TMenuItem;
    PopUP1: TMenuItem;
    Edit3: TEdit;
    Label4: TLabel;
    Button4: TButton;

    procedure Button1Click(Sender: TObject);
    procedure Edit2DblClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure WriteQuery1Click(Sender: TObject);

    procedure Memo1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure SelectQueryImageDetailsTemp1Click(Sender: TObject);
    procedure PopUP1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);




  private
    function GetUniqueFileName(const FileName: string): string;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ImageExtensions: TArray<string>;
  Directories: TArray<string>;
  BatchNumber: string;
  ImageCount: Integer;
  FileName: string;
  OutputText: TStringList;
  ImageExt: string;
  ImageDetailsFolderPath: string; // Variable to store the path of the Image_Details folder
begin
  // Construct the path for the Image_Details folder in the Downloads directory
  ImageDetailsFolderPath := TPath.Combine(TPath.GetDownloadsPath, 'Image_Details');

  // Check if the Image_Details folder exists, and create it if it doesn't
  if not DirectoryExists(ImageDetailsFolderPath) then
    ForceDirectories(ImageDetailsFolderPath);

  if DirectoryExists(Edit1.Text) then
  begin
    ImageExtensions := ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    Directories := TDirectory.GetDirectories(Edit1.Text);

    OutputText := TStringList.Create;
    try
      OutputText.Add('Series_Number' + #9 + 'Total_Images');

      for BatchNumber in Directories do
      begin
        ImageCount := 0;
        for ImageExt in ImageExtensions do
          ImageCount := ImageCount + Length(TDirectory.GetFiles(BatchNumber, '*' + ImageExt, TSearchOption.soAllDirectories));

        OutputText.Add(ExtractFileName(BatchNumber) + #9 + IntToStr(ImageCount));
      end;

      // Save the text file within the Image_Details folder
      FileName := GetUniqueFileName(TPath.Combine(ImageDetailsFolderPath, 'image_details.txt'));
      OutputText.SaveToFile(FileName);
      ShowMessage('Text file created successfully in the Downloads\Image_Details folder!');
    finally
      OutputText.Free;
    end;
  end
  else
    ShowMessage('Invalid folder path.');
end;



//Button4 Start----------------------------------------------


procedure TForm1.Button4Click(Sender: TObject);
var
  SourceFolder, DestinationFolder, FileName: string;
  ImageFiles: TStringList;
  SearchRec: TSearchRec;
  DownloadPath: string;
  Counter: Integer;
begin
  SourceFolder := Trim(Edit3.Text);

  // Debugging: Show the path being checked
  ShowMessage('Checking folder path: ' + SourceFolder);

  if not DirectoryExists(SourceFolder) then
  begin
    ShowMessage('The specified folder does not exist: ' + SourceFolder);
    Exit;
  end;

  DownloadPath := TPath.Combine(TPath.GetDownloadsPath, ExtractFileName(ExcludeTrailingPathDelimiter(SourceFolder)));

  // Debugging: Show the download path
  ShowMessage('Download path: ' + DownloadPath);

  if not DirectoryExists(DownloadPath) then
    CreateDir(DownloadPath);

  ImageFiles := TStringList.Create;
  try
    // Find all image files (you can add more extensions if needed)
    if FindFirst(TPath.Combine(SourceFolder, '*.jpg'), faAnyFile, SearchRec) = 0 then
    begin
      repeat
        ImageFiles.Add(ChangeFileExt(SearchRec.Name, ''));
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    if FindFirst(TPath.Combine(SourceFolder, '*.png'), faAnyFile, SearchRec) = 0 then
    begin
      repeat
        ImageFiles.Add(ChangeFileExt(SearchRec.Name, ''));
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    // Repeat for other image types if needed (gif, bmp, etc.)

    Counter := 0;
    repeat
      Inc(Counter);
      FileName := TPath.Combine(DownloadPath, 'ImageList' + IntToStr(Counter) + '.txt');
    until not FileExists(FileName);

    ImageFiles.SaveToFile(FileName);
    ShowMessage('Image file names saved to ' + FileName);
  finally
    ImageFiles.Free;
  end;
end;











procedure TForm1.Edit2DblClick(Sender: TObject);
var
  FileName: string;
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := 'Interbase Database (*.gdb)|*.gdb|All files (*.*)|*.*';
    if OpenDialog.Execute then
    begin
      Edit2.Text := OpenDialog.FileName;
      if FileExists(Edit2.Text) then
        Button2.Enabled := True
      else
        Button2.Enabled := False;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  if FileExists(Edit2.Text) then
    Button2.Enabled := True
  else
    Button2.Enabled := False;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FileName: string;
  OutputText: TStringList;
  Database: TFDConnection;
  Query: TFDQuery;
  ImageDetailsFolderPath: string;
begin
  if FileExists(Edit2.Text) then
  begin
    try
      // Create a connection to the database
      Database := TFDConnection.Create(nil);
      try
        Database.Params.DriverID := 'IB';
        Database.Params.Database := Edit2.Text;
        Database.Params.UserName := 'SYSDBA';
        Database.Params.Password := 'masterkey';
        Database.Connected := True;

        // Create a query to retrieve data from the database
        Query := TFDQuery.Create(nil);
        try
          Query.Connection := Database;
          Query.SQL.Text := 'SELECT series_number, COUNT(*) AS image_count FROM image_details GROUP BY series_number';
          Query.Open;

          // Create output text list
          OutputText := TStringList.Create;
          try
            OutputText.Add('Series_Number' + #9 + 'Image_Count');
            while not Query.Eof do
            begin
              OutputText.Add(Query.FieldByName('series_number').AsString + #9 + Query.FieldByName('image_count').AsString);
              Query.Next;
            end;

            // Construct the path for the Image_Details_DB folder in the Downloads directory
            ImageDetailsFolderPath := TPath.Combine(TPath.GetDownloadsPath, 'Image_Details_DB');
            if not DirectoryExists(ImageDetailsFolderPath) then
              ForceDirectories(ImageDetailsFolderPath);

            // Save the text file within the Image_Details_DB folder
            FileName := GetUniqueFileName(TPath.Combine(ImageDetailsFolderPath, 'image_details_from_DB.txt'));
            OutputText.SaveToFile(FileName);
            ShowMessage('Data exported successfully to ' + FileName);
          finally
            OutputText.Free;
          end;
        finally
          Query.Free;
        end;
      finally
        Database.Free;
      end;
    except
      on E: Exception do
        ShowMessage('An error occurred: ' + E.Message);
    end;
  end
  else
    ShowMessage('Please select a valid database file.');
end;

function TForm1.GetUniqueFileName(const FileName: string): string;
var
  BaseName, Ext: string;
  Count: Integer;
begin
  Count := 1;
  Result := FileName;
  BaseName := ChangeFileExt(FileName, '');
  Ext := ExtractFileExt(FileName);

  while FileExists(Result) do
  begin
    Result := Format('%s_%d%s', [BaseName, Count, Ext]);
    Inc(Count);
  end;
end;





//Popup Menu Start



//Query of Select_Query_Data




procedure TForm1.Memo1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
// Only show the popup menu and do not handle any other actions here
if Memo1.SelLength > 0 then
begin
PopupMenu1.Popup(ClientToScreen(MousePos).X, ClientToScreen(MousePos).Y);
Handled := True; // Prevent default context menu
end;
end;




procedure TForm1.WriteQuery1Click(Sender: TObject);
var
QueryText: string;
Lines: TStringList;
i: Integer;
begin
// Check if there is a selection in Memo1
if Memo1.SelLength > 0 then
begin
// Create a list to hold the lines
Lines := TStringList.Create;
try
// Split the selected text into lines
Lines.Text := Memo1.SelText;
// Start building the SQL query
QueryText := 'SELECT * FROM Data WHERE image_Number IN (';
// Add each line as a quoted string to the query
for i := 0 to Lines.Count - 1 do
begin
QueryText := QueryText + QuotedStr(Lines[i]);
if i < Lines.Count - 1 then
QueryText := QueryText + ', ' + sLineBreak;
end;
// Close the IN clause
QueryText := QueryText + ')';
// Copy the query to the clipboard
Clipboard.AsText := QueryText;
finally
Lines.Free; // Free the TStringList
end;
end
else
begin
ShowMessage('No items selected.');
end;
end;



//select_Query_Image_ Details

procedure TForm1.SelectQueryImageDetailsTemp1Click(Sender: TObject);
var
QueryText: string;
Lines: TStringList;
i: Integer;
begin
// Check if there is a selection in Memo1
if Memo1.SelLength > 0 then
begin
// Create a list to hold the lines
Lines := TStringList.Create;
try
// Split the selected text into lines
Lines.Text := Memo1.SelText;
// Start building the SQL query
QueryText := 'SELECT * FROM Image_Details WHERE image_Number IN (';
// Add each line as a quoted string to the query
for i := 0 to Lines.Count - 1 do
begin
QueryText := QueryText + QuotedStr(Lines[i]);
if i < Lines.Count - 1 then
QueryText := QueryText + ', ' + sLineBreak;
end;
// Close the IN clause
QueryText := QueryText + ')';
// Copy the query to the clipboard
Clipboard.AsText := QueryText;
finally
Lines.Free; // Free the TStringList
end;
end
else
begin
ShowMessage('No items selected.');
end;
end;



//select_Query_Image_ Details_Temp


procedure TForm1.PopUP1Click(Sender: TObject);
var
QueryText: string;
Lines: TStringList;
i: Integer;
begin
// Check if there is a selection in Memo1
if Memo1.SelLength > 0 then
begin
// Create a list to hold the lines
Lines := TStringList.Create;
try
// Split the selected text into lines
Lines.Text := Memo1.SelText;
// Start building the SQL query
QueryText := 'SELECT * FROM Image_Details_temp WHERE image_Number IN (';
// Add each line as a quoted string to the query
for i := 0 to Lines.Count - 1 do
begin
QueryText := QueryText + QuotedStr(Lines[i]);
if i < Lines.Count - 1 then
QueryText := QueryText + ', ' + sLineBreak;
end;
// Close the IN clause
QueryText := QueryText + ')';
// Copy the query to the clipboard
Clipboard.AsText := QueryText;
finally
Lines.Free; // Free the TStringList
end;
end
else
begin
ShowMessage('No items selected.');
end;
end;



//Button3 Start



procedure TForm1.Button3Click(Sender: TObject);
var
  ADOConnection: TADOConnection;
  ADOQuery: TADOQuery;
  FileName: string;
  OutputText: TStringList;
  ImageDetailsFolderPath: string;
begin
  // Create and configure ADO connection
  ADOConnection := TADOConnection.Create(nil);
  try
    ADOConnection.ConnectionString := 'Driver={MySQL ODBC 8.0 Unicode Driver};' +
      'Server=localhost;' +  // Replace with your server
      'Database=n22013;' +  // Replace with your database name
      'User=root;' +  // Replace with your username
      'Password=MonteCello;' +  // Replace with your password
      'Option=3;';
    ADOConnection.LoginPrompt := False;

    try
      ADOConnection.Open;

      // Create and configure ADO query
      ADOQuery := TADOQuery.Create(nil);
      try
        ADOQuery.Connection := ADOConnection;
        ADOQuery.SQL.Text := 'SELECT series_number, COUNT(*) AS image_count FROM image_details GROUP BY series_number';
        ADOQuery.Open;

        // Create output text list
        OutputText := TStringList.Create;
        try
          OutputText.Add('Series_Number' + #9 + 'Image_Count');
          while not ADOQuery.Eof do
          begin
            OutputText.Add(ADOQuery.FieldByName('series_number').AsString + #9 + ADOQuery.FieldByName('image_count').AsString);
            ADOQuery.Next;
          end;

          // Construct the path for the Image_Details_DB folder in the Downloads directory
          ImageDetailsFolderPath := TPath.Combine(TPath.GetDownloadsPath, 'Image_Details_DB_Cyr');
          if not DirectoryExists(ImageDetailsFolderPath) then
            ForceDirectories(ImageDetailsFolderPath);

          // Save the text file within the Image_Details_DB folder
          FileName := GetUniqueFileName(TPath.Combine(ImageDetailsFolderPath, 'image_details_from_DB_Cyr.txt'));
          OutputText.SaveToFile(FileName);
          ShowMessage('Data exported successfully to ' + FileName);
        finally
          OutputText.Free;
        end;
      finally
        ADOQuery.Free;
      end;
    except
      on E: Exception do
        ShowMessage('An error occurred: ' + E.Message);
    end;
  finally
    ADOConnection.Free;
  end;
end;












//Button5 Start





procedure TForm1.Button5Click(Sender: TObject);
var
  Database: TFDConnection;
  Query, DataQuery: TFDQuery;
  SeriesNumber, ImageNumber, Delimiter: string;
  ImageList, MissingImages, ExistInData, NotExistInData: TStringList;
  ImageSet: TDictionary<Integer, Boolean>;
  FirstImage, LastImage, ExpectedImage, MinImage, MaxImage: Integer;
  i: Integer;
  InClause: string;
begin
  if not FileExists(Edit2.Text) then
  begin
    ShowMessage('Please select a valid .gdb database file.');
    Exit;
  end;

  Database := TFDConnection.Create(nil);
  Query := TFDQuery.Create(nil);
  DataQuery := TFDQuery.Create(nil);
  ImageList := TStringList.Create;
  MissingImages := TStringList.Create;
  ExistInData := TStringList.Create;
  NotExistInData := TStringList.Create;
  ImageSet := TDictionary<Integer, Boolean>.Create;
  try
    // Configure the database connection
    Database.Params.DriverID := 'IB';
    Database.Params.Database := Edit2.Text;
    Database.Params.UserName := 'SYSDBA';
    Database.Params.Password := 'masterkey';
    Database.LoginPrompt := False;

    try
      Database.Connected := True;

      // Execute the query to get data from the image_details table
      Query.Connection := Database;
      Query.SQL.Text := 'SELECT series_number, image_number ' +
                        'FROM image_details ' +
                        'ORDER BY series_number, image_number';
      Query.Open;

      // Process the results and find missing images
      Memo1.Clear;
      Memo1.Lines.Add('Total Missing Image:');
      Memo1.Lines.Add('Image_Number');

      SeriesNumber := '';
      while not Query.Eof do
      begin
        if SeriesNumber <> Query.FieldByName('series_number').AsString then
        begin
          if SeriesNumber <> '' then
          begin
            // Check for missing images in the previous series
            if ImageList.Count > 0 then
            begin
              // Determine the correct delimiter based on the image_number format
              if Pos('_', ImageList[0]) > 0 then
                Delimiter := '_'
              else
                Delimiter := '-';

              // Extract the numeric part of the first and last image numbers
              FirstImage := StrToIntDef(Copy(ImageList[0], LastDelimiter(Delimiter, ImageList[0]) + 1, MaxInt), -1);
              LastImage := StrToIntDef(Copy(ImageList[ImageList.Count - 1], LastDelimiter(Delimiter, ImageList[ImageList.Count - 1]) + 1, MaxInt), -1);

              // Store images in a hash set for quick lookup
              for ImageNumber in ImageList do
              begin
                ExpectedImage := StrToIntDef(Copy(ImageNumber, LastDelimiter(Delimiter, ImageNumber) + 1, MaxInt), -1);
                if not ImageSet.ContainsKey(ExpectedImage) then
                  ImageSet.Add(ExpectedImage, True);
              end;

              // Ensure to check from the smallest to the largest image number within the series
              MinImage := FirstImage;
              MaxImage := LastImage;

              // Check for missing images within the full range
              for ExpectedImage := MinImage to MaxImage do
              begin
                if not ImageSet.ContainsKey(ExpectedImage) then
                begin
                  // Modify the format to include the previous part before the delimiter
                  MissingImages.Add(Format('%s%s%s', [Copy(ImageList[0], 1, LastDelimiter(Delimiter, ImageList[0]) - 1), Delimiter, Format('%.5d', [ExpectedImage])]));
                end;
              end;

              // Check if the first image number is greater than 1
              if MinImage > 1 then
              begin
                for ExpectedImage := 1 to MinImage - 1 do
                begin
                  MissingImages.Add(Format('%s%s%s', [Copy(ImageList[0], 1, LastDelimiter(Delimiter, ImageList[0]) - 1), Delimiter, Format('%.5d', [ExpectedImage])]));
                end;
              end;

              ImageList.Clear;
              ImageSet.Clear;
            end;
          end;

          SeriesNumber := Query.FieldByName('series_number').AsString;
        end;

        ImageNumber := Query.FieldByName('image_number').AsString;
        ImageList.Add(ImageNumber);
        Query.Next;
      end;

      // Check for missing images in the last series
      if SeriesNumber <> '' then
      begin
        if ImageList.Count > 0 then
        begin
          // Determine the correct delimiter based on the image_number format
          if Pos('_', ImageList[0]) > 0 then
            Delimiter := '_'
          else
            Delimiter := '-';

          FirstImage := StrToIntDef(Copy(ImageList[0], LastDelimiter(Delimiter, ImageList[0]) + 1, MaxInt), -1);
          LastImage := StrToIntDef(Copy(ImageList[ImageList.Count - 1], LastDelimiter(Delimiter, ImageList[ImageList.Count - 1]) + 1, MaxInt), -1);

          // Store images in a hash set for quick lookup
          for ImageNumber in ImageList do
          begin
            ExpectedImage := StrToIntDef(Copy(ImageNumber, LastDelimiter(Delimiter, ImageNumber) + 1, MaxInt), -1);
            if not ImageSet.ContainsKey(ExpectedImage) then
              ImageSet.Add(ExpectedImage, True);
          end;

          MinImage := FirstImage;
          MaxImage := LastImage;

          // Check for missing images within the full range
          for ExpectedImage := MinImage to MaxImage do
          begin
            if not ImageSet.ContainsKey(ExpectedImage) then
            begin
              // Modify the format to include the previous part before the delimiter
              MissingImages.Add(Format('%s%s%s', [Copy(ImageList[0], 1, LastDelimiter(Delimiter, ImageList[0]) - 1), Delimiter, Format('%.5d', [ExpectedImage])]));
            end;
          end;

          // Check if the first image number is greater than 1
          if MinImage > 1 then
          begin
            for ExpectedImage := 1 to MinImage - 1 do
            begin
              MissingImages.Add(Format('%s%s%s', [Copy(ImageList[0], 1, LastDelimiter(Delimiter, ImageList[0]) - 1), Delimiter, Format('%.5d', [ExpectedImage])]));
            end;
          end;
        end;
      end;

      // Display missing images in Memo1
      for i := 0 to MissingImages.Count - 1 do
      begin
        Memo1.Lines.Add(MissingImages[i]);
      end;

      // Check if missing images exist in the Data table
      DataQuery.Connection := Database;

      if MissingImages.Count > 0 then
      begin
        InClause := '';
        for i := 0 to MissingImages.Count - 1 do
        begin
          ImageNumber := MissingImages[i];
          InClause := InClause + QuotedStr(ImageNumber) + ',';
        end;
        SetLength(InClause, Length(InClause) - 1); // Remove last comma

        DataQuery.SQL.Text := 'SELECT image_number FROM Data WHERE image_number IN (' + InClause + ')';
        DataQuery.Open;
        while not DataQuery.Eof do
        begin
          ExistInData.Add(DataQuery.FieldByName('image_number').AsString);
          DataQuery.Next;
        end;

        for i := 0 to MissingImages.Count - 1 do
        begin
          ImageNumber := MissingImages[i];
          if ExistInData.IndexOf(ImageNumber) = -1 then
            NotExistInData.Add(MissingImages[i]);
        end;

        // Display images that exist in the Data table
        if ExistInData.Count > 0 then
        begin
          Memo1.Lines.Add('');
          Memo1.Lines.Add('Exist in Data Table:');
          Memo1.Lines.Add('Image_Number');
          for i := 0 to ExistInData.Count - 1 do
          begin
            Memo1.Lines.Add(ExistInData[i]);
          end;
        end;

        // Display images that do not exist in the Data table
        if NotExistInData.Count > 0 then
        begin
          Memo1.Lines.Add('');
          Memo1.Lines.Add('Not Exist in Data Table:');
          Memo1.Lines.Add('Image_Number');
          for i := 0 to NotExistInData.Count - 1 do
          begin
            Memo1.Lines.Add(NotExistInData[i]);
          end;
        end;
      end;

      ShowMessage('Complete');

    except
      on E: Exception do
        ShowMessage('An error occurred: ' + E.Message);
    end;




  finally
    Database.Free;
    Query.Free;
    DataQuery.Free;
    ImageList.Free;
    MissingImages.Free;
    ExistInData.Free;
    NotExistInData.Free;
    ImageSet.Free;
  end;
end;








procedure TForm1.Button6Click(Sender: TObject);
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(Self);
  try
    SaveDialog.Filter := 'Text files (*.txt)|*.txt|All files (*.*)|*.*';
    SaveDialog.DefaultExt := 'txt';
    if SaveDialog.Execute then
    begin
      Memo1.Lines.SaveToFile(SaveDialog.FileName);
      ShowMessage('File saved successfully.');
    end;
  finally
    SaveDialog.Free;
  end;
end;







End.
