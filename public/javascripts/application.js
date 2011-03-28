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
});

function remove_fields(link) {
    jQuery(link).prev("input[type=hidden]").val("1");
    jQuery.closest(".fields").hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    jQuery(link).parent().before(content.replace(regexp, new_id));
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
function processingTime(name,ids)
{
    var a = ids;
    spi = 'spinner_' +  a.toString();
    link = name.toString() + a.toString();
    Element.hide(link);
    Element.show(spi);

}
function processingCompleted(name,ids)
{
    var a = ids;
    spi = 'spinner_' +  a.toString();
    link = name.toString() + a.toString();
    Element.hide(spi);
    Element.show(link);


}



