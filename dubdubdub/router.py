

class KLPRouter(object):
    
    def db_for_read(self, model, **hints):
        app_label = model._meta.app_label
        if app_label == 'schools':
            return 'klp-www'
        else:
            return 'default'

    def db_for_write(self, model, **hints):
        return self.db_for_read(self, model, **hints)
