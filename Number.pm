package Lingua::RU::Number;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw();
@EXPORT_OK = qw(rur_in_words);

$VERSION = '0.03';

# Preloaded methods go here.
use vars qw(%diw %nom);

%diw = (
    0 => {
        0  => { 0 => "����",         1 => 1},
        1  => { 0 => "",             1 => 2},
        2  => { 0 => "",             1 => 3},
        3  => { 0 => "���",          1 => 0},
        4  => { 0 => "������",       1 => 0},
        5  => { 0 => "����",         1 => 1},
        6  => { 0 => "�����",        1 => 1},
        7  => { 0 => "����",         1 => 1},
        8  => { 0 => "������",       1 => 1},
        9  => { 0 => "������",       1 => 1},
        10 => { 0 => "������",       1 => 1},
        11 => { 0 => "����������",   1 => 1},
        12 => { 0 => "����������",   1 => 1},
        13 => { 0 => "����������",   1 => 1},
        14 => { 0 => "������������", 1 => 1},
        15 => { 0 => "����������",   1 => 1},
        16 => { 0 => "�����������",  1 => 1},
        17 => { 0 => "����������",   1 => 1},
        18 => { 0 => "������������", 1 => 1},
        19 => { 0 => "������������", 1 => 1},
    },
    1 => {
        2  => { 0 => "��������",    1 => 1},
        3  => { 0 => "��������",    1 => 1},
        4  => { 0 => "�����",       1 => 1},
        5  => { 0 => "���������",   1 => 1},
        6  => { 0 => "����������",  1 => 1},
        7  => { 0 => "���������",   1 => 1},
        8  => { 0 => "�����������", 1 => 1},
        9  => { 0 => "���������",   1 => 1},
    },
    2 => {
        1  => { 0 => "���",       1 => 1},
        2  => { 0 => "������",    1 => 1},
        3  => { 0 => "������",    1 => 1},
        4  => { 0 => "���������", 1 => 1},
        5  => { 0 => "�������",   1 => 1},
        6  => { 0 => "��������",  1 => 1},
        7  => { 0 => "�������",   1 => 1},
        8  => { 0 => "���������", 1 => 1},
        9  => { 0 => "���������", 1 => 1}
    }
);

%nom = (
    0  =>  {0 => "�������",  1 => "������",    2 => "���� �������", 3 => "��� �������"},
    1  =>  {0 => "�����",    1 => "������",    2 => "���� �����",   3 => "��� �����"},
    2  =>  {0 => "������",   1 => "�����",     2 => "���� ������",  3 => "��� ������"},
    3  =>  {0 => "��������", 1 => "���������", 2 => "���� �������", 3 => "��� ��������"},
    4  =>  {0 => "���������",1 => "����������",2 => "���� ��������",3 => "��� ���������"},
    5  =>  {0 => "���������",1 => "����������",2 => "���� ��������",3 => "��� ���������"}
);

my $out_rub;

sub rur_in_words
{
    my ($sum) = shift;
    my ($retval, $i, $sum_rub, $sum_kop);

    $retval = "";
    $out_rub = ($sum >= 1) ? 0 : 1;
    $sum_rub = sprintf("%0.0f", $sum);
    $sum_rub-- if (($sum_rub - $sum) > 0);
    $sum_kop = sprintf("%0.2f",($sum - $sum_rub))*100;

    my $kop = get_string($sum_kop, 0);

    for ($i=1; $i<6 && $sum_rub >= 1; $i++) {
        my $sum_tmp  = $sum_rub/1000;
        my $sum_part = sprintf("%0.3f", $sum_tmp - int($sum_tmp))*1000;
        $sum_rub = sprintf("%0.0f",$sum_tmp);

        $sum_rub-- if ($sum_rub - $sum_tmp > 0);
        $retval = get_string($sum_part, $i)." ".$retval;
    }
    $retval .= " ������" if ($out_rub == 0);
    $retval .= " ".$kop;
    $retval =~ s/\s+/ /g;
    return $retval;
}

sub get_string
{
    my ($sum, $nominal) = @_;
    my ($retval, $nom) = ('', -1);

    if (($nominal == 0 && $sum < 100) || ($nominal > 0 && $nominal < 6 && $sum < 1000)) {
        my $s2 = int($sum/100);
        if ($s2 > 0) {
            $retval .= " ".$diw{2}{$s2}{0};
            $nom = $diw{2}{$s2}{1};
        }
        my $sx = sprintf("%0.0f", $sum - $s2*100);
        $sx-- if ($sx - ($sum - $s2*100) > 0);

        if (($sx<20 && $sx>0) || ($sx == 0 && $nominal == 0)) {
            $retval .= " ".$diw{0}{$sx}{0};
            $nom = $diw{0}{$sx}{1};
        } else {
            my $s1 = sprintf("%0.0f",$sx/10);
            $s1-- if (($s1 - $sx/10) > 0);
            my $s0 = int($sum - $s2*100 - $s1*10 + 0.5);
            if ($s1 > 0) {
                $retval .= " ".$diw{1}{$s1}{0};
                $nom = $diw{1}{$s1}{1};
            }
            if ($s0 > 0) {
                $retval .= " ".$diw{0}{$s0}{0};
                $nom = $diw{0}{$s0}{1};
            }
        }
    }
    if ($nom >= 0) {
        $retval .= " ".$nom{$nominal}{$nom};
        $out_rub = 1 if ($nominal == 1);
    }
    $retval =~ s/^\s*//g;
    $retval =~ s/\s*$//g;

    return $retval;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module.

=head1 NAME

Lingua::RU::Number - Converts numbers to money sum in words (in Russian roubles)

=head1 SYNOPSIS

  use Lingua::RU::Number qw(rur_in_words);

  print rur_in_words(1.01), "\n";

=head1 DESCRIPTION

B<Lingua::RU::Number::rur_in_words()> helps you convert number to money sum in words.
Given a number, B<rur_in_words()> returns it as money sum in words, e.g.: 1.01 converted
to I<odin rubl' odna kopejka>, 2.22 converted to I<dwa rublja dwadcat' dwe kopejki>.
The target cyrillic charset is B<windows-1251>.

=head1 BUGS

seems have no bugs..

=head1 AUTHOR

Vladislav A. Safronov, E<lt>F<vlads@yandex-team.ru>E<gt>, E<lt>F<vlad@yandex.ru>E<gt>

=cut
