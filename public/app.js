var files = [];

function uploadHandler(path, status, xhr) {
  var file_parts = path.split(".");
  var extension = file_parts[file_parts.length - 1];
  if(["jpg", "png", "gif"].indexOf(extension.toLowerCase()) >= 0) {
    $("#file-listing").append("<p style: 'color:green'>" + path + "</p>");
  }
}

function errorHandler(xhr, textStatus, errorThrown) {
  $("#file-listing").html(xhr.responseText);
}

$(function(){

  $("#attachment").change(function(event) {
    $.each(event.target.files, function(index, file) {
      var reader = new FileReader();
      reader.onload = function(event) {
        object = {};
        object.filename = file.name;
        object.data = event.target.result;
        files.push(object);
      };
      reader.readAsDataURL(file);
    });
  });

  $("#ajax-attachment-upload-form").submit(function(form) {
    $.each(files, function(index, file) {
      $.ajax({url: "/ajax-upload",
            type: 'POST',
            data: {filename: file.filename, data: file.data},
            success: uploadHandler,
            error: errorHandler
      });
    });
    files = [];
    form.preventDefault();
  });

});
