-- CXA4017.A
--
--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making
--     this public release, the Government intends to confer upon all
--     recipients unlimited rights  equal to those held by the Government.
--     These rights include rights to use, duplicate, release or disclose the
--     released technical data and computer software in whole or in part, in
--     any manner and for any purpose whatsoever, and to have or permit others
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
--
-- OBJECTIVE:
--      Check that the subprograms defined in package Ada.Strings.Wide_Bounded
--      are available, and that they produce correct results.  Specifically,
--      check the subprograms Append, Delete, Index, Insert , Length,
--      Overwrite, Replace_Slice, Slice, "&", To_Bounded_Wide_String,
--      To_Wide_String, Translate, and Trim.
--
-- TEST DESCRIPTION:
--      This test demonstrates the uses of a variety of the Wide_String
--      functions found in the package Ada.Strings.Wide_Bounded, simulating
--      the operations found in a text processing environment.
--      With bounded wide strings, the length of each "line" of text can vary
--      up to the instantiated maximum, allowing one to view a page of text as
--      a series of expandable lines.  This provides flexibility in text
--      formatting of individual lines (wide strings).
--      Several subprograms are defined, all of which attempt to take
--      advantage of as many different bounded wide string utilities as
--      possible.  Often, an operation that is being performed in a subprogram
--      using a certain bounded wide string utility could more efficiently be
--      performed using a different utility.  However, in the interest of
--      including as broad coverage as possible, a mixture of utilities is
--      invoked in this test.
--      A simulated page of text is provided as a parameter to the test
--      defined subprograms, and the appropriate processing performed.  The
--      processed page of text is then compared to a predefined "finished"
--      page, and test passage/failure is based on the results of this
--      comparison.
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--      06 Nov 95   SAIC    Corrected initialization error for ACVC 2.0.1.
--
--!

with Ada.Strings;
with Ada.Strings.Wide_Bounded;
with Ada.Strings.Wide_Maps;
with Report;

procedure Cxa4017 is

begin

   Report.Test
     ("CXA4017",
      "Check that the subprograms defined in package " &
      "Ada.Strings.Wide_Bounded are available, and " &
      "that they produce correct results");

   Test_Block : declare

      Characters_Per_Line : constant Positive := 40;
      Lines_Per_Page      : constant Natural  := 4;

      package Bs_40 is new Ada.Strings.Wide_Bounded.Generic_Bounded_Length
        (Characters_Per_Line);

      use type Bs_40.Bounded_Wide_String;

      type Page_Type is
        array (1 .. Lines_Per_Page) of Bs_40.Bounded_Wide_String;

      -- Note: Misspellings below are intentional.

      Line1 : Bs_40.Bounded_Wide_String :=
        Bs_40.To_Bounded_Wide_String
          ("ada is a progrraming language designed");
      Line2 : Bs_40.Bounded_Wide_String :=
        Bs_40.To_Bounded_Wide_String ("to support the construction of long-");
      Line3 : Bs_40.Bounded_Wide_String :=
        Bs_40.To_Bounded_Wide_String ("lived, highly reliabel software ");
      Line4 : Bs_40.Bounded_Wide_String :=
        Bs_40.To_Bounded_Wide_String ("systems");

      Page : Page_Type := (1 => Line1, 2 => Line2, 3 => Line3, 4 => Line4);

      Finished_Page : Page_Type :=
        (Bs_40.To_Bounded_Wide_String
           ("Ada is a programming language designed"),
         Bs_40.To_Bounded_Wide_String ("to support the construction of long-"),
         Bs_40.To_Bounded_Wide_String
           ("lived, HIGHLY RELIABLE software systems."),
         Bs_40.To_Bounded_Wide_String (""));

      ---

      procedure Compress (Page : in out Page_Type) is
         Clear_Line : Natural := Lines_Per_Page;
      begin
         -- If two consecutive lines on the page are together less than the
         -- maximum line length, then append those two lines, move up all lower
         -- lines on the page, and blank out the last line. This algorithm
         -- works one time through the page, does not perform repetitive
         -- compression, and is designed for use with this test program only.
         for I in 1 .. Lines_Per_Page - 1 loop
            if Bs_40.Length (Page (I)) + Bs_40.Length (Page (I + 1)) <=
              Bs_40.Max_Length
            then
               Page (I) :=
                 Bs_40."&"
                   (Page (I),
                    Page (I + 1));     -- "&" (wd bnd, wd bnd)

               for J in I + 1 .. Lines_Per_Page - 1 loop
                  Page (J) :=
                    Bs_40.To_Bounded_Wide_String
                      (Bs_40.Slice
                         (Page (J + 1),
                          1,
                          Bs_40.Length (Page (J + 1))));
                  Clear_Line := J + 1;
               end loop;
               Page (Clear_Line) := Bs_40.Null_Bounded_Wide_String;
            end if;
         end loop;
      end Compress;

      ---

      procedure Format (Page : in out Page_Type) is
         Sm_Ada : Bs_40.Bounded_Wide_String :=
           Bs_40.To_Bounded_Wide_String ("ada");
         Cap_Ada  : constant Wide_String := "Ada";
         Char_Pos : Natural              := 0;
         Finished : Boolean              := False;
         Line     : Natural              := Page_Type'Last;
      begin

         -- Add a period to the end of the last line.
         while Line >= Page_Type'First and not Finished loop
            if Page (Line) /= Bs_40.Null_Bounded_Wide_String and
              Bs_40.Length (Page (Line)) <= Bs_40.Max_Length
            then
               Page (Line) := Bs_40.Append (Page (Line), '.');
               Finished    := True;
            end if;
            Line := Line - 1;
         end loop;

         -- Replace all occurrences of "ada" with "Ada".
         for Line in Page_Type'First .. Page_Type'Last loop
            Finished := False;
            while not Finished loop
               Char_Pos :=
                 Bs_40.Index
                   (Source  => Page (Line),
                    Pattern => Bs_40.To_Wide_String (Sm_Ada),
                    Going   => Ada.Strings.Backward);
               -- A zero is returned by function Index if no occurrences of the
               -- pattern wide string are found.
               Finished := (Char_Pos = 0);
               if not Finished then
                  Bs_40.Replace_Slice
                    (Source => Page (Line),
                     Low    => Char_Pos,
                     High   => Char_Pos + Bs_40.Length (Sm_Ada) - 1,
                     By     => Cap_Ada);
               end if;
            end loop;   -- while loop
         end loop;      -- for loop

      end Format;

      ---

      procedure Spell_Check (Page : in out Page_Type) is
         type Spelling_Type is (Incorrect, Correct);
         type Word_Array_Type is
           array (Spelling_Type) of Bs_40.Bounded_Wide_String;
         type Dictionary_Type is array (1 .. 2) of Word_Array_Type;

         -- Note that the "words" in the dictionary will require various
         -- amounts of Trimming prior to their use in the bounded wide
         -- string functions.
         Dictionary : Dictionary_Type :=
           (1 =>
              (Bs_40.To_Bounded_Wide_String ("  reliabel          "),
               Bs_40.To_Bounded_Wide_String ("       reliable   ")),
            2 =>
              (Bs_40.To_Bounded_Wide_String ("  progrraming  "),
               Bs_40.To_Bounded_Wide_String (" programming ")));

         Pos      : Natural := Natural'First;
         Finished : Boolean := False;

      begin

         for Line in Page_Type'Range loop

            -- Search for the first incorrectly spelled word in the Dictionary,
            -- if it is found, replace it with the correctly spelled word,
            -- using the Overwrite function.

            while not Finished loop
               Pos :=
                 Bs_40.Index
                   (Page (Line),
                    Bs_40.To_Wide_String
                      (Bs_40.Trim
                         (Dictionary (1) (Incorrect),
                          Ada.Strings.Both)),
                    Ada.Strings.Forward);
               Finished := (Pos = 0);
               if not Finished then
                  Page (Line) :=
                    Bs_40.Overwrite
                      (Page (Line),
                       Pos,
                       Bs_40.To_Wide_String
                         (Bs_40.Trim
                            (Dictionary (1) (Correct),
                             Ada.Strings.Both)));
               end if;
            end loop;

            Finished := False;

            -- Search for the second incorrectly spelled word in the
            -- Dictionary, if it is found, replace it with the correctly
            -- spelled word, using the Delete procedure and Insert function.

            while not Finished loop
               Pos :=
                 Bs_40.Index
                   (Page (Line),
                    Bs_40.To_Wide_String
                      (Bs_40.Trim
                         (Dictionary (2) (Incorrect),
                          Ada.Strings.Both)),
                    Ada.Strings.Forward);

               Finished := (Pos = 0);

               if not Finished then
                  Bs_40.Delete
                    (Page (Line),
                     Pos,
                     Pos +
                     Bs_40.To_Wide_String
                       (Bs_40.Trim
                          (Dictionary (2) (Incorrect),
                           Ada.Strings.Both))'
                       Length -
                     1);
                  Page (Line) :=
                    Bs_40.Insert
                      (Page (Line),
                       Pos,
                       Bs_40.To_Wide_String
                         (Bs_40.Trim
                            (Dictionary (2) (Correct),
                             Ada.Strings.Both)));
               end if;
            end loop;

            Finished := False;

         end loop;
      end Spell_Check;

      ---

      procedure Bold (Page : in out Page_Type) is
         Key_Word : constant Wide_String := "highly reliable";
         Bold_Mapping : constant Ada.Strings.Wide_Maps
           .Wide_Character_Mapping :=
           Ada.Strings.Wide_Maps.To_Mapping
             (From => " abcdefghijklmnopqrstuvwxyz",
              To   => " ABCDEFGHIJKLMNOPQRSTUVWXYZ");
         Pos      : Natural := Natural'First;
         Finished : Boolean := False;
      begin
         -- This procedure is designed to change the case of the phrase "highly
         -- reliable" into upper case (a type of "Bolding"). All instances of
         -- the phrase on all lines of the page will be modified.

         for Line in Page_Type'First .. Page_Type'Last loop
            while not Finished loop
               Pos      := Bs_40.Index (Page (Line), Key_Word);
               Finished := (Pos = 0);
               if not Finished then

                  Bs_40.Overwrite
                    (Page (Line),
                     Pos,
                     Bs_40.To_Wide_String
                       (Bs_40.Translate
                          (Bs_40.To_Bounded_Wide_String
                             (Bs_40.Slice
                                (Page (Line),
                                 Pos,
                                 Pos + Key_Word'Length - 1)),
                           Bold_Mapping)));

               end if;
            end loop;
            Finished := False;
         end loop;
      end Bold;

   begin

      Compress (Page);
      Format (Page);
      Spell_Check (Page);
      Bold (Page);

      for I in 1 .. Lines_Per_Page loop
         if Bs_40.To_Wide_String (Page (I)) /=
           Bs_40.To_Wide_String (Finished_Page (I)) or
           Bs_40.Length (Page (I)) /= Bs_40.Length (Finished_Page (I))
         then
            Report.Failed
              ("Incorrect modification of Page, Line " & Integer'Image (I));
         end if;
      end loop;

   exception
      when others =>
         Report.Failed ("Exception raised in Test_Block");
   end Test_Block;

   Report.Result;

end Cxa4017;