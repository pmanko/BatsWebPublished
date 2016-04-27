       class-id batsweb.breakdownpark is partial 
                inherits type System.Web.UI.Page public.
                 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat310rununit         type RunUnit.
       01 BAT310WEBF                type BAT310WEBF.
       01 mydata type batsweb.bat310Data.
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
       01  dimx              pic 9(7).
       01  dimy              pic 9(7).       
       01  WORKF                       PIC S999   VALUE ZERO.
       01  ws-new-x1        pic 9(4).
       01  ws-new-y1        pic 9(4).
       method-id Page_Load protected.
       local-storage section.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".   
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer     
           set sz to new Size(298.5, 240)
           if BAT310-BPARK-BITMAP = spaces
               set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\OFINPUT.png")) as type Bitmap
               set drawArea to new Bitmap(type Bitmap::FromFile(Server::MapPath("Images\\OFINPUT.png")), sz)
           else    
               set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\" & BAT310-BPARK-BITMAP)) as type Bitmap
               set drawArea to new Bitmap(type Bitmap::FromFile(Server::MapPath("Images\\" & BAT310-BPARK-BITMAP)), sz).
           set dimx to drawArea::Width
           set dimy to drawArea::Height
           set g to type Graphics::FromImage(drawArea)
           invoke g::Clear(type Color::White)
           set rect to new Rectangle(0, 0, 298.5, 240)
           if BAT310-BPARK-BITMAP = spaces
               invoke g::DrawImage(type Bitmap::FromFile(Server::MapPath("Images\\OFINPUT.png")) as type Bitmap, rect)      
           else
               invoke g::DrawImage(type Bitmap::FromFile(Server::MapPath("Images\\" & BAT310-BPARK-BITMAP)) as type Bitmap, rect).      
      *     IF BAT360-HITLOC-X = 0 AND BAT360-HITLOC-Y= 0
      *         GO TO SKIP-LINE.                                                                        
           set mypen to new Pen(type Brushes::Black)
                    MOVE 1 TO AA.
       030-LOOP.
            IF BAT310-HIT-LOC-X(AA) = 0 AND BAT310-HIT-LOC-Y(AA) = 0
               GO TO 040-DONE.
            IF BAT310-INFIELD-IP = "Y"
               GO TO 035-INFIELD.

            COMPUTE WS-X ROUNDED = 297 / 597 * dimx
            COMPUTE WS-Y ROUNDED = 440 / 480 * dimy.
            COMPUTE WS-X2 ROUNDED = BAT310-HIT-LOC-X(AA) / 597 * dimx
            COMPUTE WS-Y2 ROUNDED = BAT310-HIT-LOC-Y(AA) / 480 * dimy.
            IF BAT310-HIT-FLAG(AA) = "Y"
               set mypen::Brush to type Brushes::HotPink
               ELSE
               set mypen::Brush to type Brushes::Black.

            invoke g::DrawLine(mypen, ws-x, ws-y, ws-x2, ws-y2)
            IF AA < 1000
               ADD 1 TO AA
               GO TO 030-LOOP.
       035-INFIELD.
            IF ((BAT310-HIT-LOC-X(AA) LESS THAN 207 OR GREATER THAN 387)
                  OR (BAT310-HIT-LOC-Y(AA) LESS THAN 295 OR GREATER THAN 460))
                   ADD 1 TO AA
                   IF AA < 1000
                       GO TO 030-LOOP
                   else
                       GO TO 040-DONE.


            COMPUTE WS-X ROUNDED = 297 / 597 * dimx
            COMPUTE WS-Y ROUNDED = 440 / 480 * dimy.
            COMPUTE WORKF rounded = 1.86 * (297 - BAT310-HIT-LOC-X(AA))
            COMPUTE WS-NEW-X1 = BAT310-HIT-LOC-X(AA) - WORKF
            COMPUTE WORKF rounded = 1.86 * (440 - BAT310-HIT-LOC-Y(AA))
            COMPUTE WS-NEW-Y1 = BAT310-HIT-LOC-Y(AA) - WORKF.

            COMPUTE WS-X2 ROUNDED = WS-NEW-X1 / 597 * dimx
            COMPUTE WS-Y2 ROUNDED = WS-NEW-Y1 / 480 * dimy.

               IF BAT310-HIT-FLAG(AA) = "Y"
                      set mypen::Brush to type Brushes::HotPink
                      ELSE
                      set mypen::Brush to type Brushes::Black.


            invoke g::DrawLine(mypen, ws-x, ws-y, ws-x2, ws-y2)
            IF AA < 1000
               ADD 1 TO AA
               GO TO 030-LOOP.

       040-DONE.
           set Response::ContentType to "image/jpeg"
           invoke drawArea::Save(Response::OutputStream, type ImageFormat::Jpeg)
           invoke drawArea::Dispose
           invoke mypen::Dispose()
           invoke g::Dispose()
           invoke Response::End().
       SKIP-LINE.               
           goback.
       end method.
 
       end class.
