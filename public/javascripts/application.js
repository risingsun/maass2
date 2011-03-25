var $j = jQuery.noConflict();
jQuery(document).ready(function()
{
  $j('.datebalks').datepicker({
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
   jQuery('.datetime').datetimepicker({
         duration: '',
         showTime: true,
         constrainInput: false,
         stepMinutes: 1,
         stepHours: 1,
         altTimeField: '',
         time24h: false
      });

 jQuery("a.select_all").click(function(){
   jQuery("input[type='checkbox']:not([disabled='disabled'])").attr('checked', true);
  });

  

 jQuery('form[data-remote]').bind("ajax:before", function(){
   for (instance in CKEDITOR.instances){
     CKEDITOR.instances[instance].updateElement();
    }
  });

 jQuery("#status").click(function(){
   jQuery("#status").hide();
   jQuery("#in-place-edit").show();
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

  function show_status(){
    jQuery("#status_show").hide();
    jQuery("#status_form").show();
  }

  function cancel_status(){
    jQuery("#status_show").show();
    jQuery("#status_form").hide();
  }

  jQuery('#cancel').click(function(){
    jQuery('#status').hide();
    jQuery('#status_show').show();
  });

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




