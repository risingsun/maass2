/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  config.PreserveSessionOnFileBrowser = true;
  // Define changes to default configuration here. For example:
  config.language = 'en';
  // config.uiColor = '#AADC6E';
  config.uiColor = 'orange';
  //config.ContextMenu = ['Generic','Anchor','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ;

  config.height = '400px';
  config.width = '600px';

  //config.resize_enabled = false;
  //config.resize_maxHeight = 2000;
  //config.resize_maxWidth = 750;

  //config.startupFocus = true;

  // works only with en, ru, uk languages
  config.extraPlugins = "newpage";
  config.removePlugins = 'source,save,preview,templates,cut,copy,pastetext,pastefromword,about,unlink,anchor,embed,flash,table,pagebreak,attachment,blockquote';

  config.toolbar = 'Easy';

  config.toolbar_Easy =
    [
        ['Bold','Italic','Underline','Outdent','Indent','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],['Styles','Format','Font'],
        ['NewPage','Paste','Maximize','Undo','Redo','Find','Replace','SelectAll','RemoveFormat','Image','HorizontalRule','Smiley','SpecialChar','Link','Subscript','Superscript','TextColor','Strike','NumberedList','BulletedList']
    ];
};
