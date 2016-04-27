       class-id batsweb.gamesummaryszone is partial
                inherits type System.Web.UI.Page public.

       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat360rununit         type RunUnit.
       01 BAT360WEBF                type BAT360WEBF.
       01 mydata type batsweb.bat360Data.

       method-id Page_Load protected.
       local-storage section.
       01  aa    pic 9999.
       01  g           type Graphics.
       01  mypen       type Pen.
       01  mybrush      type Brush.
       01  mybrushred     type Brush.
       01  myfont      type Font.
       01  mystringformat type StringFormat.
       01  myrectangle  type Rectangle.
       01  ws-x        pic 9(4).
       01  ws-y        pic 9(4).
       01  ws-x2        pic 9(4).
       01  ws-y2        pic 9(4).
       01  ws-col      pic 9(4).
       01  ws-row      pic 9(4).
       01  testval1     pic 9.
       01  testval2     pic 99.
       01  mytext      pic x.
       01  mytext2     pic xx.
       01  dimx              pic 9(7).
       01  dimy              pic 9(7).
       01  dim2x              pic 9(7).
       01  dim2y              pic 9(7).
       01  drawArea          type Bitmap.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat360_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer
           set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\szone2.png")) as type Bitmap
           set BAT360-SZONE-WIDTH, dimx, dim2x to drawArea::Width
           set BAT360-SZONE-HEIGHT, dimy, dim2y to drawArea::Height
           set g to type Graphics::FromImage(drawArea)
           invoke g::Clear(type Color::White)
           invoke g::DrawImageUnscaled(type Bitmap::FromFile(Server::MapPath("Images\\szone2.png")) as type Bitmap, 0, 0)
           set mypen to new Pen(type Brushes::Black, 1)
      *    following lines set background and foreground color for the numbers
           set mybrush to new SolidBrush(type Color::Blue)
           set mybrushred to new SolidBrush(type Color::White)
           set myfont to new Font("Impact", 13)
      ******
           set myrectangle to new Rectangle()
      * set myflags to type TextFormatFlags::HorizontalCenter
      * set myflags to type TextFormatFlags::VerticalCenter
      * set mystringformat to new StringFormat()
      * set mystringformat::Alignment to type StringAlignment::Center
      * set mystringformat::LineAlignment to type StringAlignment::Center

           move 1 to aa.
       test-loop.
           IF BAT360-PITCH-XY-FLAG(AA) = "Y"
               NEXT SENTENCE
               ELSE
               GO TO TEST-CONT.

           COMPUTE ws-x ROUNDED = (BAT360-PITCH-X(AA) - 1)
                                   * (dimx / 21)
           COMPUTE ws-y ROUNDED = (BAT360-PITCH-Y(AA) - 1)
                                   * (dimY / 11)
           COMPUTE ws-x2 ROUNDED = (dimx / 21)
           COMPUTE ws-y2 ROUNDED = (dimy / 11)
           set myrectangle::Location to new Point(ws-x, ws-y)
           set myrectangle::Size to new Size(ws-x2, ws-y2)
           invoke g::DrawRectangle(mypen, ws-x, ws-y, ws-x2, ws-y2)
           invoke g::FillRectangle(mybrush, ws-x, ws-y, ws-x2, ws-y2)
           if ws-x > 2
               if aa = 1 or 3 or 7
                   subtract 1 from ws-x
                   else
                   subtract 2 from ws-x.

           if aa < 10
               add 1 to ws-y
               move aa to testval1
               move testval1 to mytext
               set myfont to new Font("Impact", 13)
               invoke g::DrawString(mytext, myfont, mybrushred, ws-x, ws-y)
           else
               add 4 to ws-y
               move aa to testval2
               add 10 to testval2
               move testval2 to mytext2
               set myfont to new Font("Impact", 9)
               invoke g::DrawString(mytext2, myfont, mybrushred, ws-x, ws-y).


       TEST-CONT.
           if aa < 30
               add 1 to aa
               go to test-loop.

           set Response::ContentType to "image/jpeg"
           invoke drawArea::Save(Response::OutputStream, type ImageFormat::Jpeg)
           invoke mybrush::Dispose()
           invoke drawArea::Dispose
           invoke mybrushred::Dispose()
           invoke mypen::Dispose()
           invoke myfont::Dispose()
           invoke g::Dispose()
           invoke Response::End()

           goback.
       end method.

       end class.
