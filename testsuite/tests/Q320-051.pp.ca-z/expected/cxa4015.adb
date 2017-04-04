with Cxa40150;
with Report;
with Ada.Strings;
with Ada.Strings.Wide_Fixed;
with Ada.Strings.Wide_Maps;

procedure Cxa4015 is
begin

   Report.Test
     ("CXA4015",
      "Check that the subprograms defined in " &
      "package Ada.Strings.Wide_Fixed are available, " &
      "and that they produce correct results");

   Test_Block : declare

      use Cxa40150;

      package Asf renames Ada.Strings.Wide_Fixed;
      package Maps renames Ada.Strings.Wide_Maps;

      Result_String : Wide_String (1 .. 10) :=
        (others => Ada.Strings.Wide_Space);

      Source_String1 : Wide_String (1 .. 5) := "abcde";  -- odd len Wide_String
      Source_String2 : Wide_String (1 .. 6) :=
        "abcdef"; -- even len Wide_String
      Source_String3 : Wide_String (1 .. 12) := "abcdefghijkl";
      Source_String4 : Wide_String (1 .. 12) :=
        "abcdefghij  "; -- last 2 ch pad
      Source_String5 : Wide_String (1 .. 12) :=
        "  cdefghijkl"; -- first 2 ch pad
      Source_String6 : Wide_String (1 .. 12) := "abcdefabcdef";

      Location               : Natural := 0;
      Slice_Start            : Positive;
      Slice_End, Slice_Count : Natural := 0;

      Cd_Set     : Maps.Wide_Character_Set := Maps.To_Set ("cd");
      Abcd_Set   : Maps.Wide_Character_Set := Maps.To_Set ("abcd");
      A_To_F_Set : Maps.Wide_Character_Set := Maps.To_Set ("abcdef");

      Cd_To_Xy_Map : Maps.Wide_Character_Mapping :=
        Maps.To_Mapping (From => "cd", To => "xy");

      -- Access-to-Subprogram object defined for use with specific versions of
      -- functions Index and Count.

      Map_Ptr : Maps.Wide_Character_Mapping_Function :=
        Ak_To_Zq_Mapping'Access;

   begin

      -- Procedure Move
      -- Evaluate the Procedure Move with various combinations of parameters.

      -- Justify = Left (default case)

      Asf.Move (Source => Source_String1,       -- "abcde"
      Target           => Result_String);

      if Result_String /= "abcde     " then
         Report.Failed ("Incorrect result from Move with Justify = Left");
      end if;

      -- Justify = Right

      Asf.Move
        (Source  => Source_String2,      -- "abcdef"
         Target  => Result_String,
         Drop    => Ada.Strings.Error,
         Justify => Ada.Strings.Right);

      if Result_String /= "    abcdef" then
         Report.Failed ("Incorrect result from Move with Justify = Right");
      end if;

      -- Justify = Center (two cases, odd and even pad lengths)

      Asf.Move
        (Source_String1,                 -- "abcde"
         Result_String,
         Ada.Strings.Error,
         Ada.Strings.Center,
         'x');                           -- non-default padding.

      if Result_String /= "xxabcdexxx" then  -- Unequal padding added right
         Report.Failed ("Incorrect result from Move with Justify = Center-1");
      end if;

      Asf.Move
        (Source_String2,                 -- "abcdef"
         Result_String,
         Ada.Strings.Error,
         Ada.Strings.Center);

      if Result_String /= "  abcdef  " then  -- Equal padding added on L/R.
         Report.Failed ("Incorrect result from Move with Justify = Center-2");
      end if;

      -- When the source Wide_String is longer than the target Wide_String,
      -- several cases can be examined, with the results depending on the
      -- value of the Drop parameter.

      -- Drop = Left

      Asf.Move
        (Source => Source_String3,       -- "abcdefghijkl"
         Target => Result_String,
         Drop   => Ada.Strings.Left);

      if Result_String /= "cdefghijkl" then
         Report.Failed ("Incorrect result from Move with Drop = Left");
      end if;

      -- Drop = Right

      Asf.Move (Source_String3, Result_String, Ada.Strings.Right);

      if Result_String /= "abcdefghij" then
         Report.Failed ("Incorrect result from Move with Drop = Right");
      end if;

      -- Drop = Error
      -- The effect in this case depends on the value of the justify parameter,
      -- and on whether any characters in Source other than Pad would fail to
      -- be copied.

      -- Drop = Error, Justify = Left, right overflow characters are pad.

      Asf.Move
        (Source  => Source_String4,      -- "abcdefghij  "
         Target  => Result_String,
         Drop    => Ada.Strings.Error,
         Justify => Ada.Strings.Left);

      if not (Result_String = "abcdefghij") then  -- leftmost 10 characters
         Report.Failed ("Incorrect result from Move with Drop = Error - 1");
      end if;

      -- Drop = Error, Justify = Right, left overflow characters are pad.

      Asf.Move
        (Source_String5,                 -- "  cdefghijkl"
         Result_String,
         Ada.Strings.Error,
         Ada.Strings.Right);

      if Result_String /= "cdefghijkl" then  -- rightmost 10 characters
         Report.Failed ("Incorrect result from Move with Drop = Error - 2");
      end if;

      -- In other cases of Drop=Error, Length_Error is propagated, such as:

      begin

         Asf.Move
           (Source_String3,     -- 12 characters, no Pad.
            Result_String,      -- 10 characters
            Ada.Strings.Error,
            Ada.Strings.Left);

         Report.Failed ("Length_Error not raised by Move - 1");

      exception
         when Ada.Strings.Length_Error =>
            null;   -- OK
         when others =>
            Report.Failed ("Incorrect exception raised by Move - 1");
      end;

      -- Function Index
      -- (Other usage examples of this function found in CXA4013-14.) Check
      -- when the pattern is not found in the source.

      if Asf.Index ("abcdef", "gh") /= 0 or
        Asf.Index ("abcde", "abcdef") /= 0 or  -- pattern > source
        Asf.Index ("xyz", "abcde", Ada.Strings.Backward) /= 0 or
        Asf.Index ("", "ab") /= 0 or  -- null source Wide_String.
        Asf.Index ("abcde", "  ") /= 0     -- blank pattern.
      then
         Report.Failed ("Incorrect result from Index, no pattern match");
      end if;

      -- Check that Pattern_Error is raised when the pattern is the null
      -- Wide_String.
      begin
         Location := Asf.Index (Source_String6,    -- "abcdefabcdef"
         "",                -- null pattern Wide_String.
         Ada.Strings.Forward);
         Report.Failed ("Pattern_Error not raised by Index");
      exception
         when Ada.Strings.Pattern_Error =>
            null;  -- OK, expected exception.
         when others =>
            Report.Failed
              ("Incorrect exception raised by Index, null pattern");
      end;

      -- Use the search direction "backward" to locate the particular pattern
      -- within the source Wide_String.

      Location := Asf.Index (Source_String6,         -- "abcdefabcdef"
      "de",                   -- slice 4..5, 10..11
      Ada.Strings.Backward);  -- search from right end.

      if Location /= 10 then
         Report.Failed ("Incorrect result from Index going Backward");
      end if;

      -- Function Index
      -- Use the version of Index that takes a Wide_Character_Mapping_Function
      -- parameter. Use the search directions Forward and Backward to locate
      -- the particular pattern wide string within the source wide string.

      Location :=
        Asf.Index ("akzqefakzqef", "qzq",                  -- slice 8..10
        Ada.Strings.Backward, Map_Ptr);      -- perform 'a' to 'z', 'k' to 'q'
      -- translation.
      if Location /= 8 then
         Report.Failed
           ("Incorrect result from Index w/map ptr going Backward");
      end if;

      Location :=
        Asf.Index
          ("ddkkddakcdakdefcadckdfzaaqd",
           "zq",                  -- slice 7..8
           Ada.Strings.Forward,
           Map_Ptr);      -- perform 'a' to 'z', 'k' to 'q'
      -- translation.
      if Location /= 7 then
         Report.Failed ("Incorrect result from Index w/map ptr going Forward");
      end if;

      if Asf.Index ("aakkzq", "zq", Ada.Strings.Forward, Map_Ptr) /= 2 or
        Asf.Index ("qzedka", "qz", Ada.Strings.Backward, Map_Ptr) /= 5 or
        Asf.Index ("zazaza", "zzzz", Ada.Strings.Backward, Map_Ptr) /= 3 or
        Asf.Index ("kka", "qqz", Ada.Strings.Forward, Map_Ptr) /= 1
      then
         Report.Failed ("Incorrect result from Index w/map ptr");
      end if;

      -- Check when the pattern wide string is not found in the source.

      if Asf.Index ("akzqef", "kzq", Ada.Strings.Forward, Map_Ptr) /= 0 or
        Asf.Index ("abcde", "abcdef", Ada.Strings.Backward, Map_Ptr) /= 0 or
        Asf.Index ("xyz", "akzde", Ada.Strings.Backward, Map_Ptr) /= 0 or
        Asf.Index ("", "zq", Ada.Strings.Forward, Map_Ptr) /= 0 or
        Asf.Index ("akcde", "  ", Ada.Strings.Backward, Map_Ptr) /= 0
      then
         Report.Failed
           ("Incorrect result from Index w/map ptr, no pattern match");
      end if;

      -- Check that Pattern_Error is raised when the pattern is a null
      -- Wide_String.
      begin
         Location :=
           Asf.Index
             ("akzqefakqzef",
              "",
                             -- null pattern Wide_String.
           Ada.Strings.Forward, Map_Ptr);
         Report.Failed ("Pattern_Error not raised by Index w/map ptr");
      exception
         when Ada.Strings.Pattern_Error =>
            null;  -- OK, expected exception.
         when others =>
            Report.Failed
              ("Incorrect exception raised by Index w/map ptr, null pattern");
      end;

      -- Function Index
      -- Using the version of Index testing wide character set membership,
      -- check combinations of forward/backward, inside/outside parameter
      -- configurations.

      if Asf.Index
          (Source => Source_String1,              -- "abcde"
           Set    => Cd_Set,
           Test   => Ada.Strings.Inside,
           Going  => Ada.Strings.Forward) /=
        3 or -- 'c' at pos 3.
        Asf.Index
            (Source_String6,                        -- "abcdefabcdef"
             Cd_Set,
             Ada.Strings.Outside,
             Ada.Strings.Backward) /=
          12 or   -- 'f' at position 12
        Asf.Index
            (Source_String6,                     -- "abcdefabcdef"
             Cd_Set,
             Ada.Strings.Inside,
             Ada.Strings.Backward) /=
          10 or  -- 'd' at position 10
        Asf.Index
            ("cdcdcdcdacdcdcdcd",
             Cd_Set,
             Ada.Strings.Outside,
             Ada.Strings.Forward) /=
          9      -- 'a' at position 9
      then
         Report.Failed ("Incorrect result from function Index for sets - 1");
      end if;

      -- Additional interesting uses/combinations using Index for sets.

      if Asf.Index ("cd",                               -- same size, str-set
      Cd_Set, Ada.Strings.Inside, Ada.Strings.Forward) /=
        1 or  -- 'c' at position 1
        Asf.Index
            ("abcd",                             -- same size, str-set,
             Maps.To_Set ("efgh"),                -- different contents.
             Ada.Strings.Outside,
             Ada.Strings.Forward) /=
          1 or
        Asf.Index
            ("abccd",                            -- set > Wide_String
             Maps.To_Set ("acegik"),
             Ada.Strings.Inside,
             Ada.Strings.Backward) /=
          4 or  -- 'c' at position 4
        Asf.Index ("abcde", Maps.Null_Set) /= 0 or
        Asf.Index ("",                                 -- Null string.
        Cd_Set) /= 0 or
        Asf.Index
            ("abc ab",                           -- blank included
             Maps.To_Set ("e "),                  -- in Wide_String and
             Ada.Strings.Inside,                 -- set.
             Ada.Strings.Backward) /=
          4      -- blank in Wide_Str.
      then
         Report.Failed ("Incorrect result from function Index for sets - 2");
      end if;

      -- Function Index_Non_Blank.
      -- (Other usage examples of this function found in CXA4013-14.)

      if Asf.Index_Non_Blank
          (Source => Source_String4,  -- "abcdefghij  "
           Going  => Ada.Strings.Backward) /=
        10 or
        Asf.Index_Non_Blank ("abc def ghi jkl  ", Ada.Strings.Backward) /=
          15 or
        Asf.Index_Non_Blank ("  abcdef") /= 3 or
        Asf.Index_Non_Blank ("        ") /= 0
      then
         Report.Failed ("Incorrect result from Index_Non_Blank");
      end if;

      -- Function Count
      -- (Other usage examples of this function found in CXA4013-14.)

      if Asf.Count ("abababa", "aba") /= 2 or
        Asf.Count ("abababa", "ab") /= 3 or
        Asf.Count ("babababa", "ab") /= 3 or
        Asf.Count ("abaabaaba", "aba") /= 3 or
        Asf.Count ("xxxxxxxxxxxxxxxxxxxy", "xy") /= 1 or
        Asf.Count ("xxxxxxxxxxxxxxxxxxxx", "x") /= 20
      then
         Report.Failed ("Incorrect result from Function Count");
      end if;

      -- Determine the number of slices of Source that when mapped to a
      -- non-identity map, match the pattern Wide_String.

      Slice_Count := Asf.Count (Source_String6, -- "abcdefabcdef"
      "xy", Cd_To_Xy_Map);  -- maps 'c' to 'x', 'd' to 'y'

      if Slice_Count /= 2 then  -- two slices "xy" in "mapped" Source_String6
         Report.Failed ("Incorrect result from Count with non-identity map");
      end if;

      -- If the pattern supplied to Function Count is the null Wide_String,
      -- then Pattern_Error is propagated.
      declare
         The_Null_Wide_String : constant Wide_String := "";
      begin
         Slice_Count := Asf.Count (Source_String6, The_Null_Wide_String);
         Report.Failed ("Pattern_Error not raised by Function Count");
      exception
         when Ada.Strings.Pattern_Error =>
            null;   -- OK
         when others =>
            Report.Failed ("Incorrect exception from Count with null pattern");
      end;

      -- Function Count
      -- Use the version of Count that takes a Wide_Character_Mapping_Function
      -- value as the basis of its source mapping.

      if Asf.Count ("akakaka", "zqz", Map_Ptr) /= 2 or
        Asf.Count ("akakaka", "qz", Map_Ptr) /= 3 or
        Asf.Count ("kakakaka", "q", Map_Ptr) /= 4 or
        Asf.Count ("zzqaakzaqzzk", "zzq", Map_Ptr) /= 4 or
        Asf.Count ("   ", "z", Map_Ptr) /= 0 or
        Asf.Count ("", "qz", Map_Ptr) /= 0 or
        Asf.Count ("abbababab", "zq", Map_Ptr) /= 0 or
        Asf.Count ("aaaaaaaaaaaaaaaaaakk", "zqq", Map_Ptr) /= 1 or
        Asf.Count ("azaazaazzzaaaaazzzza", "z", Map_Ptr) /= 20
      then
         Report.Failed ("Incorrect result from Function Count w/map ptr");
      end if;

      -- If the pattern supplied to Function Count is a null Wide_String, then
      -- Pattern_Error is propagated.
      declare
         The_Null_Wide_String : constant Wide_String := "";
      begin
         Slice_Count :=
           Asf.Count (Source_String6, The_Null_Wide_String, Map_Ptr);
         Report.Failed
           ("Pattern_Error not raised by Function Count w/map ptr");
      exception
         when Ada.Strings.Pattern_Error =>
            null;   -- OK
         when others =>
            Report.Failed
              ("Incorrect exception from Count w/map ptr, null pattern");
      end;

      -- Function Count returning the number of characters in a particular set
      -- that are found in source Wide_String.

      if Asf.Count (Source_String6, Cd_Set) /= 4 or  -- 2 'c' and 'd' chars.
        Asf.Count ("cddaccdaccdd", Cd_Set) /= 10
      then
         Report.Failed ("Incorrect result from Count with set");
      end if;

      -- Function Find_Token.
      -- (Other usage examples of this function found in CXA4013-14.)

      Asf.Find_Token
        (Source => Source_String6,      -- First slice with no
         Set    => Abcd_Set,            -- 'a', 'b', 'c', or 'd'
         Test   => Ada.Strings.Outside, -- is "ef" at 5..6.
         First  => Slice_Start,
         Last   => Slice_End);

      if Slice_Start /= 5 or Slice_End /= 6 then
         Report.Failed ("Incorrect result from Find_Token - 1");
      end if;

      -- If no appropriate slice is contained by the source Wide_String,
      -- then the value returned in Last is zero, and the value in First
      -- is Source'First.

      Asf.Find_Token
        (Source_String6,      -- "abcdefabcdef"
         A_To_F_Set,          -- Set of characters 'a' thru 'f'.
         Ada.Strings.Outside, -- No characters outside this set.
         Slice_Start,
         Slice_End);

      if Slice_Start /= Source_String6'First or Slice_End /= 0 then
         Report.Failed ("Incorrect result from Find_Token - 2");
      end if;

      -- Additional testing of Find_Token.

      Asf.Find_Token
        ("eabcdabcddcab",
         Abcd_Set,
         Ada.Strings.Inside,
         Slice_Start,
         Slice_End);

      if Slice_Start /= 2 or Slice_End /= 13 then
         Report.Failed ("Incorrect result from Find_Token - 3");
      end if;

      Asf.Find_Token
        ("efghijklabcdabcd",
         Abcd_Set,
         Ada.Strings.Outside,
         Slice_Start,
         Slice_End);

      if Slice_Start /= 1 or Slice_End /= 8 then
         Report.Failed ("Incorrect result from Find_Token - 4");
      end if;

      Asf.Find_Token
        ("abcdefgabcdabcd",
         Abcd_Set,
         Ada.Strings.Outside,
         Slice_Start,
         Slice_End);

      if Slice_Start /= 5 or Slice_End /= 7 then
         Report.Failed ("Incorrect result from Find_Token - 5");
      end if;

      Asf.Find_Token
        ("abcdcbabcdcba",
         Abcd_Set,
         Ada.Strings.Inside,
         Slice_Start,
         Slice_End);

      if Slice_Start /= 1 or Slice_End /= 13 then
         Report.Failed ("Incorrect result from Find_Token - 6");
      end if;

   exception
      when others =>
         Report.Failed ("Exception raised in Test_Block");
   end Test_Block;

   Report.Result;

end Cxa4015;
