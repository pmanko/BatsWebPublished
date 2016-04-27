       class-id batsweb.summarypark is partial 
                inherits type System.Web.UI.Page public.
                 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat360rununit         type RunUnit.
       01 BAT360WEBF                type BAT360WEBF.
       01 mydata type batsweb.bat360Data.
       01  drawArea          type Bitmap.
       01  g           type Graphics.
       01  mypen       type Pen.
       01  ws-x        pic 9(4).
       01  ws-y        pic 9(4).
       01  ws-x2        pic 9(4).
       01  ws-y2        pic 9(4).
       01  ratio       type Double.
       01  rect        type Rectangle.
       01  sz        type Size.
       method-id Page_Load protected.
       local-storage section.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat360_dg.CPB".   
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           set mydata to self::Session["bat360data"] as type batsweb.bat360Data
           set address of BAT360-DIALOG-FIELDS to myData::tablePointer     
           set sz to new Size(298.5, 240)
           set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\" & BAT360-BPARK-BITMAP)) as type Bitmap
           set drawArea to new Bitmap(type Bitmap::FromFile(Server::MapPath("Images\\" & BAT360-BPARK-BITMAP)), sz)
           set g to type Graphics::FromImage(drawArea)
           invoke g::Clear(type Color::White)
           set rect to new Rectangle(0, 0, 298.5, 240)
           invoke g::DrawImage(type Bitmap::FromFile(Server::MapPath("Images\\" & BAT360-BPARK-BITMAP)) as type Bitmap, rect)      
           IF BAT360-HITLOC-X = 0 AND BAT360-HITLOC-Y= 0
               GO TO SKIP-LINE.                                                                        
           set mypen to new Pen(type Brushes::Black, 2)
           compute ratio = 597 / 480.
           COMPUTE WS-X ROUNDED = 296 / 597 * 298.5
           COMPUTE WS-Y ROUNDED = 440 / 480 * 240.
           COMPUTE WS-X2 ROUNDED = BAT360-HITLOC-X / 597 * 298.5
           COMPUTE WS-Y2 ROUNDED = BAT360-HITLOC-Y / 488 * 240.

           invoke g::DrawLine(mypen, ws-x, ws-y, ws-x2, ws-y2)
           invoke mypen::Dispose().
       SKIP-LINE.               
           set Response::ContentType to "image/jpeg"
           invoke drawArea::Save(Response::OutputStream, type ImageFormat::Jpeg)
           invoke Response::End()
           invoke g::Dispose()
           invoke drawArea::Dispose.

           goback.
       end method.
 
       end class.
