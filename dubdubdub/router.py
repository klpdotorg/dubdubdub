

class KLPRouter(object):
    
    def db_for_read(self, model, **hints):
        app_label = model._meta.app_label
        if app_label == 'coords':
            return 'klp-coord'
        elif app_label == 'klp':
            return 'klp-www'
        elif app_label == 'electrep':
            return 'electrep'
        else:
            return 'default'

    def db_for_write(self, model, **hints):
        return self.db_for_read(self, model, **hints)
