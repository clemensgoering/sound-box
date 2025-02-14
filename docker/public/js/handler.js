$(document).ready(function () {

    $("#addForm").submit(function (event) {
        event.preventDefault();
        const data = {
            id: $('#id').val(),
            name: $('#name').val(),
            type: $('#type').val(),
            source: $('#source').val(),
        };
        $.ajax({
            url: "/api/rfid/",
            data: JSON.stringify(data),
            contentType: 'application/json',
            type: 'POST'
        }).done(function (result) {
            console.log(result);
        });
    });

    $("#deleteForm").submit(function (event) {
        event.preventDefault();
        const checkboxes = document.querySelectorAll('input[name="rfid"]:checked');
        const selectedRFIDs = Array.from(checkboxes).map(cb => cb.value);
        $.ajax({
            url: "/api/rfid/",
            data: JSON.stringify({ ids: selectedRFIDs }),
            contentType: 'application/json',
            type: 'DELETE'
        }).done(function (result) {
            console.log(result);
        });
    });


});
