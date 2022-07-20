#!/usr/bin/python
class FilterModule(object):
    def filters(self):
        return {
            'dictify': self.dictify,
            'remove_extra': self.remove_extra,
            'fix_archivers': self.fix_archivers
        }

    def dictify(self, list_in):

        dict_out = {}

        for item in list_in:
            name = item.pop("name")
            dict_out[name] = item

        return dict_out

    # `"extra"` is a superfluous attribute on the
    # tests and archivers that must be removed
    def remove_extra(self, dict_in):

        for value in dict_in.values():
            value.pop("extra", None)
        
        return dict_in

    # in order to match what pscheduler expects,
    # archivers' `"type"` attribute must be renamed
    # to `"archiver"` and `"spec"` to `"data"`
    def fix_archivers(self, dict_in):

        for archiver in dict_in.values():
        
            archiver["archiver"] = archiver.pop("type", "")

            archiver["data"] = archiver.pop("spec", {})
    
        return dict_in   
