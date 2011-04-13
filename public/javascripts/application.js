
jQuery(document).ready(function()
{
  jQuery('.slideshow').cycle({
    fx: 'fade' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
  });
   jQuery('#mycarousel').jcarousel({
        vertical: true,
        scroll: 2
    });

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

function add_title(fun,method){
  jQuery.ajax({
    url: "/admin/preferences/"+fun,
    dataType: "html",
    type: method,
    success: function(response){
      jQuery("#title").html(response)
    }
  });
}

function add_house(fun,method){
  jQuery.ajax({
    url: "/admin/preferences/"+fun,
    dataType: "html",
    type: method,
    success: function(response){
      jQuery("#house_name").html(response)
    }
  });
}

function event_change(id){
  var type = jQuery("input:radio[name='event']:checked").val();
  jQuery.ajax({
    beforeSend: function(){
      jQuery(".spinner").show();
    },
    complete: function(){
      jQuery(".spinner").hide();
    },
    url: "/admin/events/"+id+"/rsvp",
    dataType: "json",
    type: "GET",
    data: {
      group: type
    },
    success: function(data){
      if(data == 'Organizer') {
        jQuery("input:radio[id='event_Attending']").attr('checked', true);
      }
      else{
        jQuery("input:radio[name='event']:checked").attr('checked', true);
      }
    }
  });

}

function friend_status(id, r_type){
  jQuery.ajax({
    beforeSend: function(){
      jQuery("#spinner_"+id).show();
    },
    complete: function(){
      jQuery("#spinner_"+id).hide();
    },
    url: "/profiles/"+id+"/friendship",
    dataType: "html",
    type: r_type,
    success: function(response){
     jQuery("#friend_status_"+id).html(response);
    }
  });
}

function user_status(id){
  jQuery.ajax({
    beforeSend: function(){
      jQuery("#spinner_"+id).show();
    },
    complete: function(){
      jQuery("#spinner_"+id).hide();
    },
    url: "/profiles/"+id+"/active_user",
    dataType: "json",
    type: 'GET',
    success: function(data){
     jQuery("a#user_status_"+id).text(data);
    }
  });
}

function remove_fields(link) {
  jQuery(link).prev("input[type=hidden]").val("1");
  jQuery(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  jQuery(link).parent().before(content.replace(regexp, new_id));
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

// To Display twitter updates
function twitter_blog(user){
  new TWTR.Widget({
 version: 2,
  type: 'profile',
  rpp: 4,
  interval: 3000,
  width: 'auto',
  height: 300,
  id: 'twtr-widget',
  theme: {
    shell: {
      background: '#d9c1a7',
      color: '#141214'
    },
    tweets: {
      background: '#ffffff',
      color: '#5c573a',
      links: '#417fb5'
    }
  },
  features: {
    scrollbar: false,
    loop: true,
    live: true,
    hashtags: true,
    timestamp: true,
    avatars: false,
    behavior: 'default'
  }
}).render().setUser(user).start();
}
function gallery(){
  jQuery('div.navigation').css({
    'width' : '300px',
    'float' : 'left'
  });
  jQuery('div.content').css('display', 'block');
  jQuery('.content').galleriffic('#thumbs', {
    delay:                  2000,
    numThumbs:              12,
    preloadAhead:           0,
    enableTopPager:         true,
    enableBottomPager:      false,
    imageContainerSel:      '#slideshow',
    controlsContainerSel:   '#controls',
    loadingContainerSel:    '#loading',
    captionContainerSel:    '#caption',
    playLinkText:           'Play Slideshow',
    pauseLinkText:          'Pause Slideshow',
    prevLinkText:           '&lsaquo; Previous Photo',
    nextLinkText:           'Next Photo &rsaquo',
    onPageTransitionIn: function() {
      jQuery('#thumbs ul.thumbs').fadeIn('fast');
      jQuery('#thumbs ul.thumbs > li:visible').each(function(){
        if(jQuery(this).children("a:has('img')").length == 1){
        }else{
          jQuery(this).children('a').append("<img src = " + jQuery(this).attr('title') + "></img>");
          jQuery(this).removeAttr("title");
        }
      });
    },
    onPageTransitionOut: function(callback) {
      jQuery('#thumbs ul.thumbs').fadeOut('slow', callback);
    }
  });
}
