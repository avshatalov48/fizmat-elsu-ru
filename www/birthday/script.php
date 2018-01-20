<?PHP

   $files = "birthday/events.txt";
   $open = fopen($files, "r");
   $lines = file($files);
   fclose($open);
   $a = count($lines);

   if ($a>0) {

   for ($j=-1; $j<=1; $j++) {
   
     $Day = date("d") + $j;        
     $Month = date("m");
     $Year = date("Y");

     if ($Day == "0")
       { 
       $Day = date ("d", mktime (0, 0, 0, $Month, 0, $Year));
       $Month = date ("m", mktime (0, 0, 0, $Month, 0, $Year));
       }


     $MaxDayInMonth = date ("d", mktime (0, 0, 0, $Month+1, 0, $Year));

     if (($j==1) and ($Day>$MaxDayInMonth))
       { 
       $Day = "1";
       $Month = $Month + 1;
       if ($Month<=9) { $Month = "0" . $Month; }
       }

     if ($Day<=9) { $Day = "0" . $Day; }

     $Dates = $Day . "/" . $Month . "/";

   for ($i=0; $i!=$a; $i++)
   {

   $Find = substr($lines[$i],0,6);

   if ($Find == $Dates) { 

   $d = substr($lines[$i],0,10);
   $fio = substr($lines[$i],10, strlen($lines[$i])-10);

   if ($j==0) { print ("<TR bgcolor=\"#CBD5ED\"><TD><B>$d</B></TD><TD><B>$fio</B></TD></TR>"); }
   else { print ("<TR bgcolor=\"#CBD5ED\"><TD>$d</TD><TD>$fio</TD></TR>"); }
                      }

   }

                            }
             }


?>