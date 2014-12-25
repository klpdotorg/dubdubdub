(function() {
    klp.donation_form = {};
    var mainFormID = 'donationForm',
        $mainForm,
        $submitBtn,
        urlBase = 'donation_requirements/'

    klp.donation_form.init = function() {
        //console.log("initting donation form");
        klp.data = klp.data || {};
        $mainForm = $('#' + mainFormID);
        $submitBtn = $('#donationFormSubmitBtn');
        var donationID = getDonationID();
        if (donationID) {
            loadDonationData(donationID);
        }
        $submitBtn.click(function(e) {
            doLoading();
            var hasDonationID = getDonationID();
            if (hasDonationID) {
                saveEdit();
            } else {
                saveNew();
            }
        });
    };

    function getDonationID() {
        var donationID = $mainForm.attr("data-id");
        if (donationID) {
            return donationID;
        } else {
            return null;
        }
    }

    function loadDonationData(donationID) {
        doLoading();
        var url = urlBase + donationID;
        var $xhr = klp.api.authDo(url);
        $xhr.done(function(data) {
            stopLoading();
        });

    }

    function saveEdit() {

    }

    function saveNew() {
        doLoading();
        var data = getMainFormData();
        var $xhr = klp.api.authDo(urlBase, data, "POST");
        $xhr.done(function(data) {
            klp.utils.alertMessage("Saved. Please add items required below", "success");
            stopLoading();
        });
        $xhr.fail(function(err) {
            klp.utils.alertMessage("An error occurred while saving", "error");
            stopLoading();
            //FIXME: catch errors better
        });
    }

    function getMainFormData() {
        var data = {
            'title': $('#donationTitle').val(),
            'school': $('#donationSchool').val(),
            'organization': $('#donationOrganization').val(),
            'end_date': $('#donationEndDate').val(),
            'text': $('#donationText').val()
        };
        return data;
    }

    function doLoading() {
        $mainForm.find('input, textarea').attr("disabled", "disabled");
    }

    function stopLoading() {
        $mainForm.find('input, textarea').removeAttr("disabled");
    }

})();