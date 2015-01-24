(function() {
    var t = klp.donation_items = {};
    var template,
        $table,
        $tbody,
        urlBase = 'donation_requirements/';

    /*
        Item class
            - a "model" class for items
     */
    t.Item = function(data) {
        //GLOB = this;

        this.init = function() {
            this.data = data || {};
            this.savingXHR = null;
            this.$ = $('<tr />');
            if (this.data.hasOwnProperty('id') && this.data.id) {
                this.$.attr("data-id", this.data.id);
            }
            this.$.data("item", this);
            var html = template(this.data);
            this.$.html(html);
            $tbody.append(this.$);
            this.$name = this.$.find('.js-name');
            this.$quantity = this.$.find('.js-quantity');
            this.$unit = this.$.find('.js-unit');
            this.$category = this.$.find('.js-category');
            this.$description = this.$.find('.js-description');           
            this.onRender();
        };

        this.save = function() {
            this.data.name = this.$name.val();
            this.data.quantity = this.$quantity.val();
            this.data.unit = this.$unit.val();
            this.data.category = this.$category.val();
            this.data.description = this.$description.val();
            if (this.savingXHR && this.savingXHR.state() === 'pending') {
                this.savingXHR.abort();
            }
            if (this.data.hasOwnProperty('id')) {
                this.saveEdit();
            } else {
                this.saveNew();
            }
        };

        this.getSaveURL = function() {
            var url = urlBase + klp.donation_form.getDonationID() + '/items/';
            if (this.data.hasOwnProperty('id')) {
                var url = url + this.data.id;
            } 
            return url;
        };

        this.getSaveMethod = function() {
            return this.data.hasOwnProperty('id') ? 'PUT' : 'POST';
        };

        this.saveEdit = function() {
          if (this.isValid()) {
                var url = this.getSaveURL();
                var method = this.getSaveMethod();
                this.savingXHR = klp.api.authDo(url,this.data, method);
                this.savingXHR.done(function(data) {

                    this.savingXHR = null;
                    //that.data.id = data.id;
                });
            }
        };

        this.saveNew = function() {
            var that = this;
            if (this.isValid()) {
                var url = this.getSaveURL();
                var method = this.getSaveMethod();
                this.savingXHR = klp.api.authDo(url, this.data, method);
                this.savingXHR.done(function(data) {
                    that.data.id = data.id;
                    this.savingXHR = null;
                });
            }
        };

        this.isValid = function() {
            if (this.data.name && this.data.quantity && this.data.category) {
                return true;
            } else {
                return false;
            }
        };

        this.deleteItem = function() {
            var that = this;
            if (this.data.hasOwnProperty('id')) {
                var url = this.getSaveURL();
                var $xhr = klp.api.authDo(url, {}, "DELETE");
                $xhr.done(function(data) {
                    console.log("deleted", data);
                });
            }
            this.$.slideUp(500, function() {
                that.$.destroy();
            });
        };

        this.onRender = function() {
            var that = this;
            this.$.find('.js-name, .js-quantity, .js-unit, .js-description').on("blur", function() {
                console.log("blur event");
                that.save();
            });
            this.$.find('.js-category').on("change", function() {
                that.save();
            });
            this.$.find('.js-deleteItem').click(function(e) {
                e.preventDefault();
                if (confirm("Delete item?")) {
                    that.deleteItem();
                }
            });
        };
        
        this.init(data);

        return this;
    };


    t.init = function() {
        template = swig.compile($('#tplDonationItem').html());
        $table = $('#donationItemsTable');
        $tbody = $table.find('tbody');
        $('#addDonationItemBtn').click(function(e) {
            e.preventDefault();
            var item = new t.Item();
        });
    };

})();