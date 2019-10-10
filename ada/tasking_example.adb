with Ada.Text_IO;
procedure Tasking_Example is
   Finished : Boolean := False;
   pragma Atomic(Finished);

   task Outputter; -- task specification

   task body Outputter is -- task body
      Count : Integer := 1;
   begin
      while not Finished loop
         Ada.Text_IO.Put_Line(Integer'Image(Count));
         Count := Count + 1;
         delay 1.0; -- one second
      end loop;

      Ada.Text_IO.Put_Line("Terminating");
   end Outputter;

begin
   delay 20.0; -- 20 seconds
   Finished := True;
end Tasking_Example;
