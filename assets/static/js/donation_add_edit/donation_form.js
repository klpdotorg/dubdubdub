(function() {
    klp.donation_form = {};
    var mainFormID = 'donationForm',
        $mainForm,
        $submitBtn,
        mainFormFields,
        urlBase = 'donation_requirements/';

    klp.donation_form.init = function() {
        //console.log("initting donation form");
        klp.data = klp.data || {};
        $mainForm = $('#' + mainFormID);
        $submitBtn = $('#donationFormSubmitBtn');
        mainFormFields = {
            'title': $('#donationTitle'),
            'school': $('#donationSchool'),
            'organization': $('#donationOrganization'),
            'end_date': $('#donationEndDate'),
            'description': $('#donationText')
        };
        var donationID = getDonationID();
        if (donationID) {
            loadDonationItems(donationID);
        }

        klp.utils.schoolSelect2(mainFormFields.school);
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

    function loadDonationItems(donationID) {

    }

    function saveEdit() {
        doLoading();
        var data = getMainFormData();
        var url = urlBase + getDonationID();
        var $xhr = klp.api.authDo(url, data, "PUT");
        $xhr.done(function(data) {
            klp.utils.alertMessage("Saved successfully.", "success");
        });
        $xhr.fail(function(err) {
            klp.utils.alertMessage("Error while saving.", "error");
        });
    }

    function saveNew() {
        doLoading();
        var data = getMainFormData();
        var $xhr = klp.api.authDo(urlBase, data, "POST");
        $xhr.done(function(data) {
            klp.utils.alertMessage("Saved. Please add items required below", "success");
            stopLoading();
            var newDonationID = data.id;
            $mainForm.attr("data-id", newDonationID);
        });
        $xhr.fail(function(err) {
            klp.utils.alertMessage("An error occurred while saving", "error");
            stopLoading();
            //FIXME: catch errors better
        });
    }

    function getMainFormData() {
        return klp.utils.getFormData(mainFormFields);
    }

    function doLoading() {
        $mainForm.find('input, textarea').attr("disabled", "disabled");
    }

    function stopLoading() {
        $mainForm.find('input, textarea').removeAttr("disabled");
    }


})();