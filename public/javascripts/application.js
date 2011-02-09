var $j = jQuery.noConflict();
jQuery(document).ready(function()
{
 
  jQuery('.datebalks').datepicker({
    dateFormat:'dd M yy',
    showOn: "both",
    buttonImage: "/images/calendar.gif",
//    buttonImageOnly: true,
    yearRange: "-50:+0",
    changeMonth: true,
	changeYear: true,
    nextText: "",
    prevText: ""
  });
})

 function remove_fields(link) {
     
    $j(link).prev("input[type=hidden]").val("1");
     $j(link).closest(".fields").hide();
 }

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $j(link).parent().before(content.replace(regexp, new_id));
}



