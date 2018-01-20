//--------------------

   var months = new Array("€нвар€", "феврал€", "марта", "апрел€", "ма€", "июн€", "июл€", "августа", "сент€бр€", "окт€бр€", "но€бр€", "декабр€"),
                date = new Date(),	
                year = date.getYear();

   function WriteDate()
     {
       document.write(date.getDate() + " " + months[date.getMonth()] + " ");
       if (year < 200) document.write(1900 + year + " года");
       if (year > 2000) document.write(year + " года");

       // <!-- begin of Rambler's Top100 code -->
       document.writeln("<a class=menu href='http://top100.rambler.ru/top100/'><img src='http://counter.rambler.ru/top100.cnt?438672' alt='' width=1 height=1 border=0></a>");
       // <!-- end of Top100 code -->
     }

//--------------------

   var NAM=navigator.appName;

   function WriteModified()
     {  
       document.writeln("ќбновлено: ");
       if (NAM == "Microsoft Internet Explorer") document.write(document.lastModified.substring(0,10)+".");
       else document.write(document.lastModified+".");
     }

//--------------------

   function Loading()
     {
       dbody.background="http://fizmat.elsu.ru/images/fon.gif";
       tflash.background="http://fizmat.elsu.ru/images/banner.jpg";
     }