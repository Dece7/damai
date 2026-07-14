UPDATE `d_program_show_time_0` SET 
  show_time = DATE_ADD(show_time, INTERVAL 2 YEAR),
  show_day_time = DATE_ADD(show_day_time, INTERVAL 2 YEAR)
WHERE program_id >= 100;
