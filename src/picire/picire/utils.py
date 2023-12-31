def generate_log(self, config, prefix="", print_idx=False):
    indices = []
    for item in config:
        indices.append(item)
    indices.sort()
    info_to_print = "\t%s " % prefix
    info_to_print = info_to_print + "%d elements. " % len(indices)
    if print_idx:
        info_to_print = info_to_print + "Idx: %r" % indices
    return info_to_print