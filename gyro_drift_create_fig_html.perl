#!/usr/bin/perl

#########################################################################################
#											#
#	gyro_drift_create_fig_html.perl: create html pages for grating 			#
#						insertion/retraction plots		#
#											#
#	author: t. isobe (tisobe@cfa.harvard.edu)					#
#											#
#	last update:	Mar 28, 2006							#
#											#
# 	usage: perl  gyro_drift_create_fig_html.perl HETG INSR				#
#											#
#########################################################################################

#
#---- read directories
#

open(FH, './dir_list');
@dir_list = ();
while(<FH>){
        chomp $_;
        push(@dir_list, $_);
}
close(FH);

$bin_dir    = $dir_list[0];
$data_dir   = $dir_list[1];
$web_dir    = $dir_list[2];
$result_dir = $dir_list[3];
$fig_out    = $dir_list[4];
$fig_dir    = $dir_list[5];
$fits_dir   = $dir_list[6];
$data_save  = $dir_list[7];

#
#--- find today's date
#

($usec, $umin, $uhour, $umday, $umon, $uyear, $uwday, $uyday, $uisdst) = localtime(time);
$uyear += 1900;
$month = $umon + 1;

if($month < 10){
	$month = '0'."$month";
}
if($umday < 10){
	$umday = '0'."$umday";
}

$grating = $ARGV[0];		# grating name: HETG or LETG
$move    = $ARGV[1];		# grating move: INSR or RETR
chomp $grating;
chomp $move;

$ugrat   = uc($grating);
$umove   = uc($move);
$lgrat   = lc($grating);
$lmove   = lc($move);

$dir_name = "$web_dir".'/'."$ugrat".'_'."$umove".'/';
$gif_name = "$dir_name".'*.gif';
$in_list  = `ls $gif_name`;
@list     = split(/\s+/, $in_list);

$title1   = "$ugrat";
if($lgrat eq 'insr'){
	$title2 = 'Insertion';
}else{
	$title2 = 'Retraction';
}

$name      = "$lgrat".'_'."$lmove";
$main_html = "$name".'.html';

open(OUT2, ">$web_dir/$main_html");

print OUT2 '<html>',"\n";
print OUT2 '<head><title>',"$name ",' </title></head>',"\n";
print OUT2 '<body>',"\n";
print OUT2 '<h2>',"$title1 $title2",'</h2>',"\n";
print OUT2 '<br>',"\n",'<P>',"\n";
print OUT2 'The list below shows the selections of a plot of gyro drift rate ',"\n";
print OUT2 'around ',"$title1 $title2 ",'. To see the plot, click the "Plot" of the list, ',"\n";
print OUT2 'which opens up a new html page  with six plots on the page.',"\n";
print OUT2 '</P><P>',"\n";
print OUT2 'The plots on left panels are gryo drift rates of roll, pitch, and yaw around ',"\n";
print OUT2 "$title2",'. The red lines indicate the start time and the end time of the grating',"\n";
print OUT2 'movement. The green line fitted are 5th degree of polynomial line around the ',"\n";
print OUT2 'grating movement. The difference between the fitted line and the actual data points ',"\n";
print OUT2 'are plotted on the right side panels.',"\n";
print OUT2 '</P><br>',"\n";
print OUT2 '<table border=0 cellspacing=2 cellpadding=2>',"\n";
print OUT2 '<tr><th>Year</th><th>Year Date</th><th>Plot</th></tr>',"\n";
close(OUT2);

foreach $ent (@list){
	chomp $ent;
	@atemp = split(/\.gif/, $ent);
	$name = $atemp[0];
	@btemp = split(/www/, $atemp[0]);
	$name2 = $btemp[1];
	$html_name  = "$name".'.html';
	$html_name2 = 'http://cxc.harvard.edu/mta_days/'."$name2".'.html';

	if($ent =~ /\//){
		@btemp = split(/\//, $ent);
		$cnt = 0;
		foreach(@btemp){
			$cnt++;
		}
		$gif_name = $btemp[$cnt-1];
	}else{
		$gif_name = $ent;
	}
	@btemp = split(/\.gif/, $gif_name);
	@ctemp = split(/_/, $btemp[0]);
	$inst  = $ctemp[0];
	$ind   = $ctemp[1];
	$time  = $ctemp[2];

	open(OUT, ">$html_name");

	print OUT '<html>',"\n";
	print OUT '<head><title>'," $inst $ind $time",' </title></head>',"\n";
	print OUT '<body>',"\n";
	print OUT '<h2>Instrument:'," $inst",' Move:'," $ind",'  Time:'," $time",' </h2>',"\n";
	print OUT '<p>',"\n";
	print OUT 'The plots on left panels are gyro  drift rates of roll, pitch, and yaw around ',"\n";
	print OUT "$title2",'. The plotted values are 10**5 of the actual values.',"\n";
	print OUT ' The red lines indicate the start time and the end timd of the grating',"\n";
	print OUT 'movement. The green line fitted are 5th degree of polynomial line around the ',"\n";
	print OUT 'grating movement. The difference between the fitted line and the actual data points ',"\n";
	print OUT 'are plotted on the right side panels. The values plotted are 10**9 of the ',"\n";
	print OUT 'actual values.  Note that the time interval plotted on ',"\n";
	print OUT 'the right panels are only around the grating movement.',"\n";
	print OUT 'The values listed at the left top corner is the mean and standard deviation of ',"\n";
	print OUT 'the deviations.',"\n";
	print OUT '</P><br><br>',"\n";
	print OUT '<img src= "',"$gif_name",'", height=500 width=700>',"\n";
	print OUT '</body>',"\n";
	print OUT '</html>',"\n";

	close(OUT);

	@ct = split(//, $time);
	$year = "$ct[0]$ct[1]$ct[2]$ct[3]";
	$yday = "$ct[4]$ct[5]$ct[6]";
#
#--- add the new link to the main html page
#	
	open(OUT2, ">>$web_dir/$main_html");
	print OUT2 '<tr><td>',"$year",'</td><td>',"$yday",'</td><td>';
	print OUT2 '<a href="',"$html_name2",'", target=blank>Plot</a></td></tr>',"\n";
	close(OUT2);
}

open(OUT2,">>$web_dir/$main_html");
print OUT2 '</table>',"\n";
print OUT2 '<br><br><hr>',"\n";
print OUT2 "Last Update: $month/$umday/$uyear\n";
print OUT2 '<br><br>',"\n";
print OUT2 'If you have any quesitons, please contact',"\n";
print OUT2 "<a href='mailto:isobe\@head.cfa.harvard.edu'>isobe\@head.cfa.harvard.edu</a>","\n";
print OUT2 '</body>',"\n";
print OUT2 '</html>',"\n";
close(OUT2);

#
#--- update the main html page
#

$update = "Last Update: $month/$umday/$uyear";

open (FH, "$web_dir/gyro_main.html");
@save_line = ();
while(<FH>){
	chomp $_;
	if($_ =~ /Last Update/){
		push(@save_line, $update);
	}else{
		push(@save_line, $_);
	}
}
close(FH);

open(OUT, ">$web_dir/gyro_main.html");
foreach $ent (@save_line){
	print OUT "$ent\n";
}
close(OUT);

system("rm data_out dir_list");
