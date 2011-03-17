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

  var submit_handler = function(element, id, value) {
    alert("Edited id '" + id + "' value '" + value + "'");
    return true;
  };

  var cancel_handler = function(element) {
    // Nothing
    return true;
  };

 jQuery("#in-place-edit").inPlaceEdit({
    submit : submit_handler,
    cancel : cancel_handler
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
  jQuery("#form"+c).toggle();
}

function show_comment(c){
  jQuery("#show"+c).toggle();
}

function cancel_comment(c){
  jQuery("#form"+c).hide();
}


function content_show_hide(div_id){
  id=jQuery(div_id)
  jQuery(id).slideToggle();
}

jQuery('#search_q').live('focus.search_query_field', function(){
  if(jQuery(this).val()=='Search for Friends'){
    jQuery(this).val('');
  }
});

jQuery('#search_q').live('blur.search_query_field', function(){
  if(jQuery(this).val()==''){
    jQuery(this).val('Search for Friends');
  }
});

jQuery('#search_all').live('focus.search_query_field', function(){
  if(jQuery(this).val()=='Search'){
    jQuery(this).val('');
  }
});

jQuery('#search_all').live('blur.search_query_field', function(){
  if(jQuery(this).val()==''){
    jQuery(this).val('Search');
  }
});

jQuery('#cancel').click(function(){
    $j('#status').hide();
    $j('#status_show').show();
  });

jQuery('#status_show').click(function(){
    $j('#status').show();
    $j('#status_show').hide();
  });

