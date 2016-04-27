       class-id batsweb.parkdetailpark is partial 
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
       01  WS-NEW-X2                 PIC 9(4) VALUE 0.
       01  WS-NEW-Y2                 PIC 9(4) VALUE 0.    
       01  Downlocx              pic 9(4).
       01  Downlocy              pic 9(4).
       01  Uplocx              pic 9(4).
       01  Uplocy              pic 9(4).       
       method-id Page_Load protected.
       local-storage section.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".        
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer  
           IF BAT310-INFIELD-IP = "Y"
                  MOVE "if1.png" TO BAT310-BPARK-BITMAP.
           set sz to new Size(597, 480)
           set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\" & BAT310-BPARK-BITMAP)) as type Bitmap
           set drawArea to new Bitmap(type Bitmap::FromFile(Server::MapPath("Images\\" & BAT310-BPARK-BITMAP)), sz)
           set dimx to drawArea::Width
           set dimy to drawArea::Height
           set g to type Graphics::FromImage(drawArea)
           invoke g::Clear(type Color::White)
           set rect to new Rectangle(0, 0, 597, 480)
           invoke g::DrawImage(type Bitmap::FromFile(Server::MapPath("Images\\" & BAT310-BPARK-BITMAP)) as type Bitmap, rect)      

           set mypen to new Pen(type Brushes::Red, 1.5).


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
            IF BAT310-HIT-TYPE (AA) EQUAL "GB"
                set mypen::Brush to type Brushes::Red
                ELSE
                IF BAT310-HIT-TYPE (AA) EQUAL "FB"
                  set mypen::Brush to type Brushes::Blue
                  ELSE
                IF BAT310-HIT-TYPE (AA) EQUAL "LD"
                  set mypen::Brush to type Brushes::Magenta
                  ELSE
                IF BAT310-HIT-TYPE (AA) EQUAL "PU"
                  set mypen::Brush to type Brushes::Black
                  ELSE
                IF BAT310-HIT-TYPE (AA) EQUAL "BU"
                  set mypen::Brush to type Brushes::Pink.


            IF BAT310-HIT-TYPE (AA) not EQUAL "PU"
                invoke g::DrawLine(mypen, ws-x, ws-y, ws-x2, ws-y2).


            IF BAT310-HIT-AB-KEY(AA) NOT = SPACES
                set mypen::Brush to type Brushes::Yellow.


            IF BAT310-HIT-FLAG(AA) = "Y"
                   COMPUTE WS-NEW-X1 = WS-X2 - 3
                   COMPUTE WS-NEW-X2 = WS-X2 + 3
                   COMPUTE WS-NEW-Y1 = WS-Y2 - 3
                   COMPUTE WS-NEW-Y2 = WS-Y2 + 3
                   invoke g::DrawEllipse(mypen, ws-new-x1, ws-new-y1, 6, 6)
                   else
                   COMPUTE WS-NEW-Y1 = WS-Y2 - 3
                   COMPUTE WS-NEW-Y2 = WS-Y2 + 3
                   invoke g::DrawLine(mypen, ws-x2, ws-new-y1, ws-x2, ws-new-y2)
                   COMPUTE WS-NEW-X1 = WS-X2 - 3
                   COMPUTE WS-NEW-X2 = WS-X2 + 3
                   invoke g::DrawLine(mypen, ws-new-x1, ws-y2, ws-new-x2, ws-y2).



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
           IF BAT310-HIT-TYPE (AA) EQUAL "GB"
               set mypen::Brush to type Brushes::Red
               ELSE
               IF BAT310-HIT-TYPE (AA) EQUAL "FB"
                 set mypen::Brush to type Brushes::Blue
                 ELSE
               IF BAT310-HIT-TYPE (AA) EQUAL "LD"
                 set mypen::Brush to type Brushes::Magenta
                 ELSE
               IF BAT310-HIT-TYPE (AA) EQUAL "PU"
                 set mypen::Brush to type Brushes::Black
                 ELSE
               IF BAT310-HIT-TYPE (AA) EQUAL "BU"
                 set mypen::Brush to type Brushes::Pink.


           IF BAT310-HIT-TYPE (AA) not EQUAL "PU"
               invoke g::DrawLine(mypen, ws-x, ws-y, ws-x2, ws-y2).


           IF BAT310-HIT-AB-KEY(AA) NOT = SPACES
               set mypen::Brush to type Brushes::Yellow.




           IF BAT310-HIT-FLAG(AA) = "Y"
                  COMPUTE WS-NEW-X1 = WS-X2 - 3
                  COMPUTE WS-NEW-X2 = WS-X2 + 3
                  COMPUTE WS-NEW-Y1 = WS-Y2 - 3
                  COMPUTE WS-NEW-Y2 = WS-Y2 + 3
                  invoke g::DrawEllipse(mypen, ws-new-x1, ws-new-y1, 6, 6)
                  else
                  COMPUTE WS-NEW-Y1 = WS-Y2 - 3
                  COMPUTE WS-NEW-Y2 = WS-Y2 + 3
                  invoke g::DrawLine(mypen, ws-x2, ws-new-y1, ws-x2, ws-new-y2)
                  COMPUTE WS-NEW-X1 = WS-X2 - 3
                  COMPUTE WS-NEW-X2 = WS-X2 + 3
                  invoke g::DrawLine(mypen, ws-new-x1, ws-y2, ws-new-x2, ws-y2).



           IF AA < 1000
              ADD 1 TO AA
              GO TO 030-LOOP.

       040-DONE.

            IF (DOWNLOCX = 0 AND DOWNLOCY = 0) OR (UPLOCX = 0 AND UPLOCY = 0)
               GO TO 210-RECTANGLE.
            IF DOWNLOCX < UPLOCX
                   MOVE DOWNLOCX TO WS-X
                   COMPUTE WS-X2 = UPLOCX - DOWNLOCX
                   ELSE
                   MOVE UPLOCX TO WS-X
                   COMPUTE WS-X2 = DOWNLOCX - UPLOCX.

            IF DOWNLOCY < UPLOCY
                   MOVE DOWNLOCY TO WS-Y
                   COMPUTE WS-Y2 = UPLOCY - DOWNLOCY
                   ELSE
                   MOVE UPLOCY TO WS-Y
                   COMPUTE WS-Y2 = DOWNLOCY - UPLOCY.


            set mypen::Brush to type Brushes::Blue
            set mypen::Width to 2.0
            invoke g::DrawRectangle(mypen, ws-x, ws-y, ws-x2, ws-y2).

        210-RECTANGLE.
           set Response::ContentType to "image/jpeg"
           invoke drawArea::Save(Response::OutputStream, type ImageFormat::Jpeg)
           invoke drawArea::Dispose
           invoke mypen::Dispose()
           invoke g::Dispose().
           invoke Response::End().

                                                                        
           goback.
       end method.
 
       end class.
