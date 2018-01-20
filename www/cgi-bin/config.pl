#!/usr/bin/perl
#
# config.pl - файл конфигураций и настроек
#


# список расширений файлов, которые надо индексировать
$file_ext = '\.(html|htm|phtml|shtml)$';

# список директорий, которые не нужно индексировать
$no_index_dir = '(images|cgi-bin|scripts|styles|examples|logs)$';

# список файлов, которые не нужно индексировать
$no_index_files = '(robots.txt|gbook/rec.phtml|photo/info.html)';

# путь к директории, где расположены Ваши html файлы
# Если index.pl расположен в той же директории, оставьте этот параметр как есть ".", ".." - на уровень вверх
$base_dir = "..";

# URL Вашего сайта
$base_url = "http://fizmat.elsu.ru/";

# Full word indexing ("YES" or "NO")
$FULL_WORD = "YES";

#index or not numbers (set   $numbers = ""   if you don't want to index numbers)
$numbers = '0-9';

#minimum word length to index (минимальная длина слов в запросе) =3
$min_length = 3;

#number of results per page = 20 (max количество страниц выводимые при результате поиска)
$res_num=10;

#use escape chars (like &Egrave; or &x255;)
$use_esc = "YES";

#index META tags (индексировать META теги) = "YES"
$use_META = "NO";

#index IMG ALT tag
$use_ALT = "YES";

# site size
# 1 - Tiny    ~1Mb
# 2 - Medium  ~10Mb
# 3 - Big     ~50Mb
# 4 - Large   >100Mb
$site_size = 2;

# Delete hyphen at the end of strings
$del_hyphen = "YES";

# Define length of page description in output
# and use META description ("YES") or first "n" characters of page ("NO")
$descr_size = 256;
$use_META_descr = "NO";

# List of stopwords
$use_stop_words = "YES";
@stop_words = qw(and any are but can had has have her here him his
 how its not our out per she some than that the their them then there
 these they was were what you);

# Change below only if you need multilanguage support
# With default settings script will work with
# English, Russian (win1251 encoding) and most European languages

# Capital letters
$CAP_LETTERS = '\xC0-\xDF\xA8';

# Lower case letters
$LOW_LETTERS = '\xE0-\xFF\xB8';

# Change this as above
sub to_lower_case {
   my $str = shift;
   $str =~ tr{\xC0-\xDF\xA8}{\xE0-\xFF\xB8};
   return $str;
}

#--- end of configuration --- 

if ($site_size == 1) { $HASHSIZE = 20001 }
elsif ($site_size == 3) { $HASHSIZE = 100001 }
elsif ($site_size == 4) { $HASHSIZE = 300001 }
else { $HASHSIZE = 50001 }

%stop_words = ();
if ($use_stop_words eq "YES") {
    foreach $word (@stop_words) { $stop_words{$word} = "" }
}

1;