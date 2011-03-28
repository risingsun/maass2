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

  jQuery("#student_check_year").change(function() {
    year = this.value
    jQuery.ajax({
      url: "/student_checks/view_year_students",
      dataType: "json",
      type: "GET",
      data: {
        group: year
      },
      success: function(data){
        jQuery('#student_check_profile_id').find('option').remove() ;
        var options = '' ;
        var year = data
        for (var i = 0; i < year.length; i++) {
          if (i==0)
          {
            options += '<option selected value="' + year[i][1] + '">' + year[i][0] + '</option>';
          }
          else
          {
            options += '<option value="' + year[i][1] + '">' + year[i][0] + '</option>';
          }
        }
        jQuery('#student_check_profile_id').html(options);   // populate select box with array
      }
    });
  })

  jQuery(function() {
    jQuery('#cropbox').Jcrop({
      onChange: update_crop,
      onSelect: update_crop,
      setSelect: [0, 0, 500, 500],
      aspectRatio: 1
    })
  });

  function update_crop(coords) {
    jQuery('#photo_crop_x').val(coords.x);
    jQuery('#photo_crop_y').val(coords.y);
    jQuery('#photo_crop_w').val(coords.w);
    jQuery('#photo_crop_h').val(coords.h);
  }

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

function show_partial(p){
    jQuery("#par_"+p).show();
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
