#!/usr/bin/perl -w
#
# Audacious Interface for XChat
#
# Copyright 2010 Kevin Lange <kevin.lange@phpwnage.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

$script_name        = "Audacious2 Interface for XChat2";
$script_version     = "0.4.4";
$script_description = "Control Audacious2 from XChat2";

$aud_version = `audacious --version`;
chop $aud_version;

Xchat::register($script_name,$script_version,$script_description,"");

Xchat::print("Loaded \002".$script_name."\002.");

Xchat::hook_command("aud_now_playing","aud_now_playing",{help_text => 'Announce currently playing song to channel.'});
Xchat::hook_command("aud_next","aud_next",{help_text => 'Advance to the next song in the playlist.'});
Xchat::hook_command("aud_prev","aud_prev",{help_text => 'Reverse to the previous since in the playlist.'});
Xchat::hook_command("aud_play","aud_play",{help_text => 'Start playing'});
Xchat::hook_command("aud_pause","aud_pause",{help_text => 'Pause playback.'});
Xchat::hook_command("aud_playlist","aud_playlist",{help_text => 'Display the playlist.'});
Xchat::hook_command("aud_clear","aud_clear",{help_text => 'Clear all songs from the playlist.'});
Xchat::hook_command("aud_add","aud_add",{help_text => 'Add a song to the playlist. If no file is specified, you will be prompted to select a file.'});
Xchat::hook_command("aud_shuffle","aud_shuffle",{help_text => 'Toggle shuffle.'});

sub aud_nowPlaying {
    if (`ps -A | grep audacious` =~ /audacious/) {
        # Get current playing song information.
        $song_info = `audtool current-song `;
        chop $song_info;
        $song_length = `audtool current-song-length`;
        chop $song_length;
        return "♫ プレイ中: ".$song_info." (".$song_length.")";
    } else {
        return "";
    }
}

sub aud_now_playing
{
    $np = aud_nowPlaying();
    if (length($np) > 0) {
        Xchat::command("me ".$np);
    } else {
        Xchat::print("Audacious is not currently running.");
    }
    return Xchat::EAT_ALL;
}

sub aud_next
{
    # Skip to the next track.
    eval `audtool playlist-advance`;
    $song_info = `audtool current-song `;
    Xchat::print("▶▶ ".$song_info);
    return Xchat::EAT_ALL;
}

sub aud_prev
{
    # Skip to the previous track.
    eval `audtool playlist-reverse`;
    $song_info = `audtool current-song `;
    Xchat::print("◀◀ ".$song_info);
    return Xchat::EAT_ALL;
}

sub aud_play
{
    # Start playback.
    eval `audtool --playback-play`;
    $song_info = `audtool current-song `;
    Xchat::print(" ▶ ".$song_info);
    return Xchat::EAT_ALL;
}

sub aud_pause
{
    # Pause playback.
    eval `audtool playback-pause`;
    $song_info = `audtool current-song `;
    Xchat::print("▌▌ ".$song_info);
    return Xchat::EAT_ALL;
}

sub aud_clear
{
    # Clear playlist
    eval `audtool playlist-clear`;
    Xchat::print("▌▌ 【何もない】");
    return Xchat::EAT_ALL;
}

sub aud_playlist
{
    # Display playlist
    $songs = `audtool playlist-display`;
    Xchat::print("Audacious playlist:");
    Xchat::print($songs);
    return Xchat::EAT_ALL;
}

sub aud_add
{
    # Show file selection window to add song to playlist
    exec `audtool filebrowser-show`;
    return Xchat::EAT_ALL;
}

sub aud_shuffle
{
    exec `audtool playlist-shuffle-toggle`;
    $shuffle_status = `audtool playlist-shuffle-status`;
    chomp $shuffle_status;
    Xchat::print("Shuffle is ".$shuffle_status.".");
    return Xchat::EAT_ALL;
}
