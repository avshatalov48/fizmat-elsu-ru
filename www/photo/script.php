<?PHP

   $maxcols = 5;

   // Считывание в массив информации о файлах, их размеры

   $files = "info.txt";
   $open = fopen($files, "r");
   $lines = file($files);
   fclose($open);
   $a = count($lines);

   // Считывание в массив комментариев к файлам

   $files = "title.txt";
   $open = fopen($files, "r");
   $tit = file($files);
   fclose($open);

   if ($a>0)
   {

     $col=0; 
     $row = ceil($a/$maxcols);

     print ("<b style=\"font-size: 12pt;\">Количество фотографий: $a</b>\n");
     print ("<hr width=\"100%\" align=\"center\" style=\"color: #304078;\" size=\"1\">\n");
     print ("<p></p>");

     print ("<TABLE cellSpacing=\"1\" cellPadding=\"8\" border=0 width=\"100%\" bgcolor=\"#304078\">\n");
     print ("<TBODY align=\"center\" valign=\"top\">\n");

     for ($j=1; $j<=$row; $j++)
     {
       print ("<TR bgcolor=\"#DFE3F4\">");

       for ($i=1; $i<=$maxcols; $i++)
       {
         if ($col<$a)
           {
           $filename=trim(substr($lines[$col],0,7));
           $info=trim(substr($lines[$col],8,strlen($lines[$col])));
           print ("<TD width=\"120\"><A HREF=\"real.phtml?number=$col\" target=\"_blank\"><IMG LOWSRC=\"http://fizmat.elsu.ru/images/one.gif\" SRC=\"small/$filename\" ALT=\"$tit[$col]\" style=\"border: solid 1 #304078;\"></A><BR><SMALL class=referat>$info<BR><A HREF=\"big/$filename\" class=\"menu\">$filename</A></SMALL></TD>\n");
           }
         else { print ("<TD valign=\"middle\" width=\"120\"><SMALL class=referat>фотографии<BR>нет</SMALL></TD>"); }
         $col=$col+1;
       }

       print ("</TR>");
     }

     print ("</TBODY></TABLE>\n");
     print ("<p></p>\n");
     print ("<hr width=\"100%\" align=\"center\" style=\"color: #304078;\" size=\"1\">\n");
     print ("Щелкните на картинку, чтобы получить изображение большего размера в отдельном окне\n");
   }


?>