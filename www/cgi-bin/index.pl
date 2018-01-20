#!/usr/bin/perl
#
# index.pl - файл-скрипт для индексирования
#


# require 'C:\www\cgi-bin\config.pl';
require './config.pl';
$| = 1;

#DEFINE CONSTANTS
$cfn = 0;
$kbcount = 0;
if ($use_esc eq "YES") { &html_esc() }

if (exists($ENV{'GATEWAY_INTERFACE'})) {print "Content-Type: text/plain\n\n"}

open FINFO, ">finfo" or die "Could not open finfo.";
open SITEWORDS, ">sitewords" or die "Could not open sitewords.";
open WORD_IND, ">word_ind" or die "Could not open word_ind.";
binmode(WORD_IND);

@time=localtime(time);
$time="$time[2]:$time[1]:$time[0]";
print "Scan started: $time\n";


&scan_files($base_dir);

@time=localtime(time);
$time="$time[2]:$time[1]:$time[0]";
print "Scan finished: $time\n";
print "Creating databases. Please wait, this can take several minuts.\n";

close(FINFO);

    foreach $word (sort keys %words) {
    	$wordpos{$word} .= pack("NN", tell(SITEWORDS), tell(WORD_IND) );
    	print SITEWORDS "$word\n";
    	print WORD_IND pack("N", length($words{$word}));
    	print WORD_IND $words{$word};
    };

close(SITEWORDS);
close(WORD_IND);

    &build_hash;

@time=localtime(time);
$time="$time[2]:$time[1]:$time[0]";
print "Indexing finished: $time\n";


sub  scan_files {

     my $dir=$_[0];
     my (@dirs,@files,$filename,$newdir,$list,$url);

     opendir(DIR,$dir) or (warn "Cannot open $dir: $!" and next);
     @dirs=grep {!(/^\./) && -d "$dir/$_"} readdir(DIR);
     rewinddir(DIR);
     @files=grep {!(/^\./) && /$file_ext/i && -f "$dir/$_"} readdir(DIR);
     closedir (DIR);

     for $list(0..$#dirs) {
     	 if ($dirs[$list] =~ m#$no_index_dir#i) {next};
         $newdir=$dir."/".$dirs[$list];
         &scan_files ($newdir);
     }
     for $list(0..$#files) {
         $filename=$dir."/".$files[$list];
         if ($filename =~ m#$no_index_files#i) {next};
         ($url = $filename) =~ s/^$base_dir\///;
         $url = $base_url.$url;
         &index_file($filename,$url);
         $cfn++;
     }
     return 1;
}


sub index_file {
    my $filename=$_[0];
    my $url=$_[1];
    local $/;
    open FILE, $filename;
    @dum = stat(FILE);
    $size = int($dum[7] / 1024);
    $kbcount += $size;
    print "$cfn -> $filename; totalsize -> $kbcount\n";
    $html_text = <FILE>;
    $html_text =~ s#<TITLE>\s*(.*?)\s*</TITLE># #is;
    $title = $1;
    if ($title eq "") {$title = "No title"};
    if ($use_META eq "YES") { ($keywords,$description) = &get_META_info($html_text) }
    if ($use_ALT eq "YES") {
    	 @alt = ($html_text =~ m/<IMG +[^>]*ALT="([^"]*)"[^>]*>/igs );
    	 $alt = join " ", @alt;
    }
    if ($del_hyphen eq "YES") { $html_text = &del_hyphen($html_text) }

##################################### PHP #####################################

    $html_text =~ s/<\?php.*?\?>/ /igs;
    $html_text =~ s/<\?.*?\?>/ /igs;

##################################### PHP #####################################

    $html_text =~ s/<script.*?<\/script>/ /igs;
    $html_text =~ s/<style.*?<\/style>/ /igs;
    $html_text =~ s/<!--.*?-->/ /igs;

#    ($plain_text = $html_text) =~ s/<(?:[^>'"]*|(['"]).*?\1)*>/ /gs;
    ($plain_text = $html_text) =~ s/<[^>]*>/ /gs;
    $plain_text = $plain_text." ".$title." ".$keywords." ".$decription." ".$alt;
    $plain_text =~ s/\s+/ /gs;
    if ($use_esc eq "YES") { $plain_text =~ s/(&.*?;)/&esc2char($1)/egs; }
    $plain_text =~ s/ {2,}/ /gs;
    if (($use_META_descr eq "YES") & ($description ne "")) { $descript = substr($description,0,$descr_size) }
    else { $descript = substr($plain_text,0,$descr_size) }
    @wwd = ($plain_text =~ m/([a-zA-Z$CAP_LETTERS$LOW_LETTERS$numbers]+-[a-zA-Z$CAP_LETTERS$LOW_LETTERS$numbers]+)/gs);
    $wwd = join " ", @wwd;
    $plain_text =~ s/[^a-zA-Z$CAP_LETTERS$LOW_LETTERS$numbers]/ /gs;
    $plain_text = $plain_text." ".$wwd;
    $plain_text =~ s/ {2,}/ /gs;
    $plain_text =~ tr/A-Z/a-z/;
    $plain_text = to_lower_case($plain_text);
    $fileinfo = $url."::".$size."::".$title."::".$descript;
    $pos = tell(FINFO);
    print FINFO "$fileinfo\n";
    
    @results=split (/ /,$plain_text);
    %seen = ();
    @uniq = ();
    foreach $item (@results) {
    	if (exists($stop_words{$item})) { next } 
        unless ($seen{$item}) {
            $seen{$item} = 1;
            push(@uniq, $item);
        };
    };
    foreach (@uniq){
       chomp($_);
       if (length($_) >= $min_length) { $words{$_}.= pack("N", $pos) }
    }
};     # sub index_file



sub build_hash {
    
    for ($i=0; $i<$HASHSIZE; $i++) {$hash_array[$i] = ""};
    foreach $word (keys %words) {
        @letters = unpack("C*", $word);
        if ($FULL_WORD eq "YES") { $subbound = scalar(@letters)-3 }
        else { $subbound = 1 }
        if (scalar(@letters)==3) {$subbound = 1}
        
        for ($i=0; $i<$subbound; $i++){
    	    $a = $letters[$i];
       	    $b = $letters[$i+1];
    	    $c = $letters[$i+2];
    	    $d = $letters[$i+3];
    	    $num = int( ($a*14511 - $b*13779 + $c*$d*94333)/5 ) % $HASHSIZE;
    	    $hash_array[$num] .= ($word."::");
    	};   # for $i
    };   # foreach $word
    
    open HASH, ">hash" or die "Could not open hash.";
    binmode(HASH);
    open HASHWORDS, ">hashwords" or die "Could not open hashwords.";
    binmode(HASHWORDS);

    $zzz = pack("N", 0);
    print HASHWORDS $zzz;
    for ($i=0; $i<$HASHSIZE; $i++){
    	
        if ($hash_array[$i] eq "") {print HASH $zzz};
        if ($hash_array[$i] ne "") {
            @dum = split (/::/,$hash_array[$i]);
            $pos = pack("N", tell(HASHWORDS));
            print HASH $pos;
            $wnum = pack("N", scalar(@dum));
            print HASHWORDS $wnum;
            foreach (@dum) { print HASHWORDS $wordpos{$_} };
        };   # if
    
    }; # for $i

close(HASH);
close(HASHWORDS);

};     # sub build_hash


sub html_esc {
    %html_esc = (
        "&Agrave;" => chr(192),
        "&Aacute;" => chr(193),
        "&Acirc;" => chr(194),
        "&Atilde;" => chr(195),
        "&Auml;" => chr(196),
        "&Aring;" => chr(197),
        "&AElig;" => chr(198),
        "&Ccedil;" => chr(199),
        "&Egrave;" => chr(200),
        "&Eacute;" => chr(201),
        "&Eirc;" => chr(202),
        "&Euml;" => chr(203),
        "&Igrave;" => chr(204),
        "&Iacute;" => chr(205),
        "&Icirc;" => chr(206),
        "&Iuml;" => chr(207),
        "&ETH;" => chr(208),
        "&Ntilde;" => chr(209),
        "&Ograve;" => chr(210),
        "&Oacute;" => chr(211),
        "&Ocirc;" => chr(212),
        "&Otilde;" => chr(213),
        "&Ouml;" => chr(214),
        "&times;" => chr(215),
        "&Oslash;" => chr(216),
        "&Ugrave;" => chr(217),
        "&Uacute;" => chr(218),
        "&Ucirc;" => chr(219),
        "&Uuml;" => chr(220),
        "&Yacute;" => chr(221),
        "&THORN;" => chr(222),
        "&szlig;" => chr(223),
        "&agrave;" => chr(224),
        "&aacute;" => chr(225),
        "&acirc;" => chr(226),
        "&atilde;" => chr(227),
        "&auml;" => chr(228),
        "&aring;" => chr(229),
        "&aelig;" => chr(230),
        "&ccedil;" => chr(231),
        "&egrave;" => chr(232),
        "&eacute;" => chr(233),
        "&ecirc;" => chr(234),
        "&euml;" => chr(235),
        "&igrave;" => chr(236),
        "&iacute;" => chr(237),
        "&icirc;" => chr(238),
        "&iuml;" => chr(239),
        "&eth;" => chr(240),
        "&ntilde;" => chr(241),
        "&ograve;" => chr(242),
        "&oacute;" => chr(243),
        "&ocirc;" => chr(244),
        "&otilde;" => chr(245),
        "&ouml;" => chr(246),
        "&divide;" => chr(247),
        "&oslash;" => chr(248),
        "&ugrave;" => chr(249),
        "&uacute;" => chr(250),
        "&ucirc;" => chr(251),
        "&uuml;" => chr(252),
        "&yacute;" => chr(253),
        "&thorn;" => chr(254),
        "&yuml;" => chr(255),
        "&nbsp;" => " ",
        "&amp;" => " ",
        "&quote;" => " ",
    );

}


sub esc2char {
    my ($esc) = @_;
    my $char = "";
    if ($esc =~ /&[a-zA-Z]*;/) { $char = $html_esc{$esc} }
    elsif ($esc =~ /&x([0-9]{1,3});/) { $char = chr($1) }
    return $char;
}


sub get_META_info {
    my ($html) = @_;
    $keywords    = ($html =~ s/<meta\s*name=\"?keywords\"?\s*content=\"?([^\"]*)\"?>//is) ? $1 : '';
    $description = ($html =~ s/<meta\s*name=\"?description\"?\s*content=\"?([^\"]*)\"?>//is) ? $1 : '';
    return ($keywords, $description)
}

sub del_hyphen {
    my ($text) = @_;
    local $/;
    $text =~ s/-\n//gs;
    return $text;
}

