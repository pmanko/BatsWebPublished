       class-id batsweb.summaryrunners is partial 
                inherits type System.Web.UI.Page public.
                 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat360rununit         type RunUnit.
       01 BAT360WEBF                type BAT360WEBF.
       01 mydata type batsweb.bat360Data.
       01  drawArea          type Bitmap.
       01  g           type Graphics.
       01  myfont      type Font.
       01  mybrushblack     type Brush.
       01  ws-x        pic 9(4).
       01  ws-y        pic 9(4).  
       01  rect1       type Rectangle.
       01  sf          type StringFormat.
       
       method-id Page_Load protected.
       local-storage section.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat360_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer     
           set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\runnerfield.png")) as type Bitmap
           set g to type Graphics::FromImage(drawArea)
           set mybrushblack to new SolidBrush(type Color::Black)
           set myfont to new Font("Impact", 13)
           invoke g::Clear(type Color::White)
           invoke g::DrawImageUnscaled(type Bitmap::FromFile(Server::MapPath("Images\\runnerfield.png")) as type Bitmap, 0, 0)
           set sf to new StringFormat()
           set sf::Alignment to type StringAlignment::Center
           set rect1 = new Rectangle(94, 95, 90, 20)
           set sf::LineAlignment to type StringAlignment::Far;
           invoke g::DrawString(BAT360-1-RUNNER::Trim, myfont, mybrushblack, rect1, sf)     
           set rect1 = new Rectangle(47, 0, 90, 20)
           set sf::LineAlignment to type StringAlignment::Center;
           invoke g::DrawString(BAT360-2-RUNNER::Trim, myfont, mybrushblack, rect1, sf)     
           set rect1 to new Rectangle(0, 75, 90, 20)
           set sf::LineAlignment to type StringAlignment::Near;
           invoke g::DrawString(BAT360-3-RUNNER::Trim, myfont, mybrushblack, rect1, sf)
           set Response::ContentType to "image/jpeg"
           invoke drawArea::Save(Response::OutputStream, type ImageFormat::Jpeg)
           invoke mybrushblack::Dispose()
           invoke drawArea::Dispose
           invoke myfont::Dispose()
           invoke g::Dispose()
           invoke sf::Dispose()
           invoke Response::End()
           goback.
       end method.
 
       end class.
