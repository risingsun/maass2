jQuery(document).ready(function()
{
$("#cancel").click(function(){
    $("#status").hide();
    $("#status_show").show();
  });

  $("#status_show").click(function(){
    $("#status").show();
    $("#status_show").hide();
  });
})
