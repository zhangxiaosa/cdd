def generate_log(config, prefix="", print_idx=False, threshold=None):
    indices = []
    for item in config:
        indices.append(item)
    indices.sort()
    info_to_print = "\t%s " % prefix
    info_to_print += "%d elements. " % len(indices)

    if print_idx:
        if threshold != None:
            if len(indices) > threshold:
                info_to_print += "Idx: %r ... %r" % (indices[:5], indices[-5:])
            else:
                info_to_print += "Idx: %r" % indices

    return info_to_print
