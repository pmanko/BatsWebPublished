       class-id batsweb.breakdownszone is partial 
                inherits type System.Web.UI.Page public.
 
       working-storage section.
       COPY "Y:\sydexsource\shared\WS-SYS.CBL".
       01 bat310rununit         type RunUnit.
       01 BAT310WEBF                type BAT310WEBF.
       01 mydata type batsweb.bat310Data.

       method-id Page_Load protected.
       local-storage section.
       01  aa    pic 9999.
       01  g           type Graphics.
       01  mypen       type Pen.
       01  mylemonbrush      type Brush.
       01  mybrightgreenbrush      type Brush.
       01  mygreenbrush      type Brush.
       01  myroyalbluebrush     type Brush.
       01  myredbrush     type Brush.
       01  myblackbrush     type Brush.
       01  myyellowbrush     type Brush.
       01  mywhitebrush     type Brush.
       01  mycyanbrush     type Brush.
       01  myfont      type Font.
       01  myfont2      type Font.
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
       01  Downlocx              pic 9(4).
       01  Downlocy              pic 9(4).
       01  Uplocx              pic 9(4).
       01  Uplocy              pic 9(4).
       01  pfc    type PrivateFontCollection.
       01  pfc2    type PrivateFontCollection.
       linkage section.
           COPY "Y:\SYDEXSOURCE\BATS\bat310_dg.CPB".
       procedure division using by value param-sender as object
                                         param-e as type System.EventArgs.
           set mydata to self::Session["bat310data"] as type batsweb.bat310Data
           set address of BAT310-DIALOG-FIELDS to myData::tablePointer      
           IF BAT310-SZONE-BMP = "SZONE1"
               set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\szone1.png")) as type Bitmap
           else
               set drawArea to type Bitmap::FromFile(Server::MapPath("Images\\szone1c.png")) as type Bitmap.
           set dimx, dim2x to drawArea::Width
           set dimy, dim2y to drawArea::Height
           set g to type Graphics::FromImage(drawArea)
           invoke g::Clear(type Color::White)
           IF BAT310-SZONE-BMP = "SZONE1"
               invoke g::DrawImageUnscaled(type Bitmap::FromFile(Server::MapPath("Images\\szone1.png")) as type Bitmap, 0, 0)
           else
               invoke g::DrawImageUnscaled(type Bitmap::FromFile(Server::MapPath("Images\\szone1c.png")) as type Bitmap, 0, 0).
            set mypen to new Pen(type Brushes::Blue, 1)
      **    following lines set background and foreground color for the numbers
            set pfc to new PrivateFontCollection()
            set pfc2 to new PrivateFontCollection()
            invoke pfc2::AddFontFile(Server::MapPath("fonts\\ZURCHLXC.TTF")).
            invoke pfc::AddFontFile(Server::MapPath("fonts\\ZURCHBXC.TTF")).
            
            set mylemonbrush to new SolidBrush(type Color::LemonChiffon)
            set mybrightgreenbrush to new SolidBrush(type Color::Chartreuse)
            set mygreenbrush to new SolidBrush(type Color::Green)
            set myroyalbluebrush to new SolidBrush(type Color::RoyalBlue)
            set myredbrush to new SolidBrush(type Color::Red)
            set mycyanbrush to new SolidBrush(type Color::Cyan)
            set myblackbrush to new SolidBrush(type Color::Black)
            set myyellowbrush to new SolidBrush(type Color::Yellow)
            set mywhitebrush to new SolidBrush(type Color::White)
            set myfont to new Font(pfc::Families[0], 10)
            set myfont2 to new Font(pfc2::Families[0], 8)

            move 1 to aa, bb.
       test-loop.
            IF BAT310-PRINT-RESULT (AA,BB) EQUAL SPACES
                GO TO 100-LOOP-BACK.

            COMPUTE ws-x ROUNDED = (bb - 3)
                                    * (dimx / 36)
            COMPUTE ws-y ROUNDED = (aa - 1)
                                    * (dimY / 21)
            COMPUTE ws-x2 ROUNDED = (dimx / 36)
            COMPUTE ws-y2 ROUNDED = (dimy / 21)
            IF BAT310-DISPLAY-TYPE NOT = "T"
                subtract 1 from ws-x2, ws-y2.
            IF BAT310-PRINT-RESULT(AA,BB) = "B"
               MOVE "b" TO mytext
               else
               move BAT310-PRINT-RESULT(AA,BB) TO mytext.

            IF BAT310-DISPLAY-TYPE = "T"
               GO TO 150-PITCH-TYPES.


            IF BAT310-DISPLAY-TYPE = " " OR "R"
              IF BAT310-PRINT-RESULT (AA,BB) EQUAL "B"
                NEXT SENTENCE
              Else
              IF BAT310-PRINT-RESULT (AA,BB) EQUAL "T" OR "S" OR "F"
                invoke g::FillRectangle(mylemonbrush, ws-x, ws-y, ws-x2, ws-y2)
              Else
              IF BAT310-PRINT-RESULT (AA,BB) EQUAL "H" OR "O" OR "K"
                IF BAT310-VIDFOUND(AA,BB) = "Y"
                  invoke g::FillRectangle(mybrightgreenbrush, ws-x, ws-y, ws-x2, ws-y2)
                  else
                  invoke g::FillRectangle(mygreenbrush, ws-x, ws-y, ws-x2, ws-y2).


            IF BAT310-VIDFOUND(AA,BB) = "Y"
              if BAT310-PRINT-RESULT (AA,BB) EQUAL "H" OR "O" OR "K"
               next sentence
               else
               invoke g::DrawRectangle(mypen, ws-x, ws-y, ws-x2, ws-y2).



      *     if ws-x > 1
      *         subtract 1 from ws-x.



            IF BAT310-DISPLAY-TYPE = " " OR "R"
              IF BAT310-PRINT-RESULT (AA,BB) EQUAL "B"
      *          if ws-x > 1
      *          subtract 1 from ws-x
      *          end-if
      *          add 2 to ws-y
      *          set myfont to new Font("dotumche", 8)
                invoke g::DrawString(mytext, myfont2, myroyalbluebrush, ws-x, ws-y)
              END-IF
              IF BAT310-PRINT-RESULT (AA,BB) EQUAL "T" OR "S" OR "F"
      *          add 2 to ws-y
      *          set myfont to new Font("dotumche", 7.5)
                invoke g::DrawString(mytext, myfont, myredbrush, ws-x, ws-y)
              END-IF
              IF BAT310-PRINT-RESULT (AA,BB) EQUAL "H" OR "O" OR "K"
      *          add 1 to ws-y
                if ws-x > 2
                      subtract 2 from ws-x
                end-if
      *          IF WS-X > 1
      *             SUBTRACT 1 FROM WS-X
      *              end-if
      *          END-IF
                IF BAT310-VIDFOUND(AA,BB) = "Y"
      *             set myfont to new Font("pfc::Families[0]", 7, type FontStyle::Bold)
      *             set myfont to new Font("pfc::Families[0]", 10)

                   invoke g::DrawString(mytext, myfont, myblackbrush, ws-x, ws-y)
                   else
      *             set myfont to new Font("pfc::Families[0]", 7, type FontStyle::Bold)
      *             set myfont to new Font("pfc::Families[0]", 10)

                   invoke g::DrawString(mytext, myfont, myyellowbrush, ws-x, ws-y).

        100-LOOP-BACK.

            ADD 1 TO BB.
            IF BB LESS THAN 39
                GO TO TEST-LOOP.
            MOVE 1 TO BB.
            ADD 1 TO AA
            IF AA LESS THAN 22
                GO TO TEST-LOOP.
            GO TO 200-DONE.

        150-PITCH-TYPES.
             IF BAT310-PRINT-TYPE(AA,BB) EQUAL "F" OR "T" OR "N"
                invoke g::FillRectangle(myredbrush, ws-x, ws-y, ws-x2, ws-y2)
                ELSE
                invoke g::FillRectangle(mycyanbrush, ws-x, ws-y, ws-x2, ws-y2).


             move BAT310-PRINT-TYPE(AA,BB) TO mytext.
      *       IF WS-X > 2
      *              SUBTRACT 2 FROM WS-X.
      *       add 1 to ws-y.
             IF BAT310-PRINT-TYPE(AA,BB) EQUAL "F" OR "T" OR "N"
      *          set myfont to new Font("dotumche", 10, type FontStyle::Bold)
                invoke g::DrawString(mytext, myfont, mywhitebrush, ws-x, ws-y)
                ELSE
      *          set myfont to new Font("dotumche", 10, type FontStyle::Bold)
                invoke g::DrawString(mytext, myfont, myblackbrush, ws-x, ws-y).

            ADD 1 TO BB.
            IF BB LESS THAN 39
                GO TO TEST-LOOP.
            MOVE 1 TO BB.
            ADD 1 TO AA
            IF AA LESS THAN 22
                GO TO TEST-LOOP.



        200-DONE.
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
           invoke mypen::Dispose()
           invoke myfont::Dispose()
           set Response::ContentType to "image/jpeg"
           invoke drawArea::Save(Response::OutputStream, type ImageFormat::Jpeg)
           invoke drawArea::Dispose
           invoke g::Dispose()
           invoke Response::End()


           goback.
       end method.
 
       end class.
