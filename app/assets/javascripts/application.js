// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .


jQuery(document).ready(function(){
  var source = new EventSource('/users/listen');
  source.addEventListener('enter', function(e){
    data = jQuery.parseJSON( e.data );
    url = "http://localhost:3000"+data.song.song.url
    var audioElement = document.getElementById("current_song");
  if (data["load"] && audioElement.src != url)
  {
    document.getElementById('song_name').innerHTML=data.song.song.url;
    audioElement.src = data["song"].song.url;
    audioElement.load();
    audioElement.play();
  }
  });
});

