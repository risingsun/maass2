var $j = jQuery.noConflict();
jQuery(document).ready(function()
{
  jQuery('.datebalks').datepicker({
    dateFormat:'dd M yy',
    showOn: "both",
    buttonImage: "/images/calendar.gif",
    buttonImageOnly: true,
    yearRange: "-50:+0",
    changeMonth: true,
    changeYear: true,
    nextText: "",
    prevText: ""

  });

  jQuery("a.select_all").click(function(){

    jQuery("input[type='checkbox']:not([disabled='disabled'])").attr('checked', true);
  });

  jQuery('form[data-remote]').bind("ajax:before", function(){
    for (instance in CKEDITOR.instances){
      CKEDITOR.instances[instance].updateElement();
    }
  });
});


function remove_fields(link) {
     
  $j(link).prev("input[type=hidden]").val("1");
  $j(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $j(link).parent().before(content.replace(regexp, new_id));
}

function add_comment(c){
  jQuery("#form"+c).show();
}

function show_comment(c){
  jQuery("#show"+c).show();
}

function cancel_comment(c){
  jQuery("#form"+c).hide();
}

function content_show_hide(element,tagid, head){
  jQuery('#personal_info_header').toggle();
}


Effect.SlideUpAndDown = function(element,tagid, head) {
  element = $(element);
  tagid = $(tagid);

  if(element.visible(element))
  {
    new Effect.SlideUp(element, {
      duration: 0.25
    });
    //$(tagid).removeClassName('active');
    $(head.id+"_img").src = replace($(head.id+"_img").src, 'hide', 'show')


  }
  else {
    new Effect.SlideDown(element, {
      duration: 0.25
    });
    //$(tagid).addClassName('active');
    $(head.id+"_img").src = replace($(head.id+"_img").src, 'show', 'hide')
  //lnk.childNodes[0].src = replace(lnk.childNodes[0].src, 'show', 'hide')
  }

}

