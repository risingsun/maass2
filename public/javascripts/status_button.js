var $j = jQuery.noConflict();
jQuery(document).ready(function()
{
$j("#cancel").click(function(){
    $j("#status").hide();
    $j("#status_show").show();
  });

  $j("#status_show").click(function(){
    $j("#status").show();
    $j("#status_show").hide();
  });
})
