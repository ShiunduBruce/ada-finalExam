with Ada.Calendar, tools;

procedure finalExam is
   task patient;
   task hospital is
      entry vaccinate;
   end hospital;


   task body hospital is
      patient : Natural := 1;
      subtype opening_time is Positive range 1..15;
      package time_generator is new tools.Random_Generator(opening_time);
   begin
      delay Duration(Float(time_generator.GetRandom) / 10.0);
      loop
         select
            accept vaccinate  do
               tools.Output.Puts("Vaccinating patient " & Natural'Image(patient), 1);
               patient := patient + 1;
            end vaccinate;
         or
            terminate;
         end select;

         end loop;
   end hospital;
      task body patient is
         vaccinated : Boolean := False;
         waiting_time : Ada.Calendar.Time := Ada.Calendar."+"( Ada.Calendar.Clock, 0.5 );
      begin
         select
            hospital.vaccinate;
            vaccinated := True;
         or
            delay until waiting_time;
         end select;

         if vaccinated then
            tools.Output.Puts("I got vaccinated ", 1);
         else
            tools.Output.Puts("Did not get vaccinated ", 1);
         end if;

      end patient;

begin
   null;
end finalExam;
