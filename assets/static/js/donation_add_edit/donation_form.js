(function() {
    var t = klp.donation_form = {};
    var mainFormID = 'donationForm',
        $mainForm,
        $submitBtn,
        mainFormFields,
        urlBase = 'donation_requirements/';

    t.init = function() {
        //console.log("initting donation form");
        klp.data = klp.data || {};
        klp.donation_items.init();
        $mainForm = $('#' + mainFormID);
        $submitBtn = $('#donationFormSubmitBtn');
        mainFormFields = {
            'title': $('#donationTitle'),
            'school': $('#donationSchool'),
            'organization': $('#donationOrganization'),
            'end_date': $('#donationEndDate'),
            'description': $('#donationText')
        };
        var donationID = t.getDonationID();
        if (donationID) {
            loadDonationItems(donationID);
        }

        klp.utils.schoolSelect2(mainFormFields.school);
        $submitBtn.click(function(e) {
            doLoading();
            var hasDonationID = t.getDonationID();
            if (hasDonationID) {
                saveEdit();
            } else {
                saveNew();
            }
        });
    };

    t.getDonationID = function() {
        var donationID = $mainForm.attr("data-id");
        if (donationID) {
            return donationID;
        } else {
            return null;
        }
    };

    function loadDonationItems(donationID) {
        var url = urlBase + donationID + "/items/";
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            var items = data.results;
            _(items).each(function(item) {
                var thisItem = new klp.donation_items.Item(item);
            });
        });
    }

    function saveEdit() {
        doLoading();
        var data = getMainFormData();
        var url = urlBase + t.getDonationID();
        var $xhr = klp.api.authDo(url, data, "PUT");
        $xhr.done(function(data) {
            klp.utils.alertMessage("Saved successfully.", "success");
            stopLoading();
        });
        $xhr.fail(function(err) {
            klp.utils.alertMessage("Error while saving.", "error");
            stopLoading();
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
        //FIXME: ideally, handle not returning 'end_date' key in utils func
        var data = klp.utils.getFormData(mainFormFields);
        if (!data.end_date) {
            delete(data.end_date);
        }
        return data;
    }

    function doLoading() {
        $mainForm.find('input, textarea').attr("disabled", "disabled");
    }

    function stopLoading() {
        $mainForm.find('input, textarea').removeAttr("disabled");
    }


})();