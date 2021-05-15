with Ada.Calendar, tools;

procedure finalExam is
   type pstring is access String;
   use type Ada.Calendar.Time;
   closing_time : Ada.Calendar.Time := Ada.Calendar."+"( Ada.Calendar.Clock, 12.0 );
   current_time : Ada.Calendar.Time := Ada.Calendar."+"( Ada.Calendar.Clock, 0.0 );

   protected MedicalOfficer is
        procedure increase;
        procedure getNumber;
    private
        num_of_served : Natural := 0;
    end MedicalOfficer;

    protected body MedicalOfficer is
        procedure increase is
        begin
            num_of_served := num_of_served + 1;
        end increase;
        procedure getNumber is
        begin
            tools.Output.Puts("Total number of patients" & num_of_served'Image & " vaccinated");
        end getNumber;
   end MedicalOfficer;

   task type  patient(name : pstring);

   task type hospital is
      entry vaccinate;
   end hospital;

   type phos is access hospital;
   phospital : array (1..3) of phos;

   task body hospital is
      patients : Natural := 0;
      subtype opening_time is Positive range 1..15;
      package time_generator is new tools.Random_Generator(opening_time);
   begin
      delay Duration(Float(time_generator.GetRandom) / 10.0);
      while current_time < closing_time loop
         select
            when patients < 5 =>
               accept vaccinate  do
                  tools.Output.Puts("Vaccinating patient ", 1);
                  patients := patients + 1;
                  --patients := patients - 1;
                  MedicalOfficer.increase;
               end vaccinate;
               delay 0.5;
         current_time := Ada.Calendar."+"( Ada.Calendar.Clock, 0.0 );
         end select;
      end loop;
      ---tools.Output.Puts("HOSPITAL HAS CLOSED ", 1);
   end hospital;
      task body patient is
         vaccinated : Boolean := False;
         waiting_time : Ada.Calendar.Time := Ada.Calendar."+"( Ada.Calendar.Clock, 0.5 );
         package get_vaccine is new tools.Random_Generator(Boolean);
         wants_vaccinated : Boolean;
         trials : Natural := 0;
         subtype Index is Positive range 1..3;
         package Ind_Generator is new tools.Random_Generator(Index);
         hospital_index : Index;

     begin
      wants_vaccinated :=  get_vaccine.GetRandom;
      hospital_index := Ind_Generator.GetRandom;

      while trials < 2 loop
         if wants_vaccinated then
            select
               phospital(hospital_index).vaccinate;
               vaccinated := True;
               tools.Output.Puts(name.all & " got vaccinated ", 1);
               exit;
            or
               delay until waiting_time;
            end select;
         else
            wants_vaccinated := get_vaccine.GetRandom;
         end if;
         trials := trials  + 1;
         waiting_time := Ada.Calendar."+"( Ada.Calendar.Clock, 0.5 );

      end loop;

      if not vaccinated then
           tools.Output.Puts(name.all & " couldnt get vaccine today", 1);
      end if;
      exception
       when Tasking_Error => tools.Output.Puts("Hospital closed? ", 1);
   end patient;
      type ppatient is access patient;
      ptpatients : array (1..20) of ppatient;
begin
   for i in 1..3 loop
      phospital(i) := new hospital;
   end loop;

   for i in 1..20 loop
      ptpatients(i) := new patient(new String'("Patient-" & Integer'Image(i) ) );
      delay 0.5;
   end loop;
   delay until closing_time;
   MedicalOfficer.getNumber;
end finalExam;
