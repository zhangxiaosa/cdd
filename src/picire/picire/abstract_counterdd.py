# Copyright (c) 2016-2020 Renata Hodovan, Akos Kiss.
#
# Licensed under the BSD 3-Clause License
# <LICENSE.rst or https://opensource.org/licenses/BSD-3-Clause>.
# This file may not be copied, modified, or distributed except
# according to those terms.

import logging
import collections
import time
import math
import sys
import copy
from . import utils
from datetime import datetime

logger = logging.getLogger(__name__)


class AbstractCounterDD(object):
    """
    Abstract super-class of the CDD class.
    """

    # Test outcomes.
    PASS = 'PASS'
    FAIL = 'FAIL'

    def __init__(self, test, split, id_prefix=(), other_config={}):
        self._test = test
        self._split = split
        self._id_prefix = id_prefix
        self.init_probability = other_config["init_probability"]

    def __call__(self, config):
        
        tstart = time.time()
        self.original_config = config[:]

        # initialize counters
        self.counters = [0 for i in range(len(config))]

        # initialize current best config idx, all true
        self.current_best_config_idx = [True for i in range(len(config))]
        
        run = 0
        while not self._test_done():
            logger.info('Run #%d', run)
            logger.info('\tConfig size: %d', self.get_current_config_size())
            
            # select a subsequence for testing
            logger.info("%s: marker1" % datetime.now().strftime("%H:%M:%S"))
            config_idx_to_delete = self.sample()
            logger.info("%s: marker2" % datetime.now().strftime("%H:%M:%S"))
            logger.info("%s: marker3" % datetime.now().strftime("%H:%M:%S"))
            log_to_print = utils.generate_log(config_idx_to_delete, "Try deleting", print_idx=True, threshold=30)
            logger.info(log_to_print)
            config_log_id = ('r%d' % run, )

            outcome = self._test_config(config_idx_to_delete, config_log_id)
            # FAIL means current variant cannot satisify the property
            logger.info("%s: marker4" % datetime.now().strftime("%H:%M:%S"))
            
            # if the subset cannot be deleted
            if outcome == self.FAIL:
                for idx in config_idx_to_delete:
                    self.counters[idx] = self.counters[idx] + 1
                # for key in self.counters.keys():
                #     if key in deleteconfig:
                #         self.counters[key] = self.counters[key] + 1
                logger.info("%s: marker5" % datetime.now().strftime("%H:%M:%S"))
                logger.info("%s: marker6" % datetime.now().strftime("%H:%M:%S"))
                if len(config_idx_to_delete) == 1:
                    # assign the counter to maxsize and never consider this element
                    self.counters[config_idx_to_delete[0]] = -1
            
            # if the subset can be deleted
            else:
                logger.info("%s: marker7" % datetime.now().strftime("%H:%M:%S"))
                for idx in config_idx_to_delete:
                    self.counters[idx] = -1
                    self.current_best_config_idx[idx] = False
                # print successfully deleted idx
                # self.printIdx(deleteconfig, "Deleted")
                log_to_print = utils.generate_log(config_idx_to_delete, "Deleted", print_idx=True, threshold=30)
                logger.info(log_to_print)
                logger.info("%s: marker8" % datetime.now().strftime("%H:%M:%S"))
            
            run += 1

        logger.info("Final size: %d/%d" % (self.get_current_config_size(), len(config)))
        logger.info("Execution time at this level: %f s" % (time.time() - tstart))
        return self.map_idx_to_config(self.current_best_config_idx)
    
    def get_current_config_size(self):
        return sum(self.current_best_config_idx)

    def _processElementToPreserve(toBePreserve):
        raise NotImplementedError()

    def _process(self, config, outcome):
        raise NotImplementedError()
    
    def compute_size(self, counter):
        size = round(-1 / math.log(1 - self.init_probability, math.e))
        i = 0
        while i < counter:
            size = math.floor(size * (1 - pow(math.e, -1)))
            i = i + 1
        size = min(size, len(self.counters))
        size = max(size, 1)
        return size
    
    def increase_all_counters(self):
        for idx in range(len(self.counters)):
            self.counters[idx] = self.counters[idx] + 1

    def find_min_counter(self):
        current_min = sys.maxsize
        for counter in self.counters:
            if counter is not -1 and current_min > counter:
                current_min = counter
        return current_min
    
    def sample(self):
        config_idx_to_delete = []
        
        # filter out those removed elements (counter is -1)
        available_idx_with_counter = [(idx, counter) for idx, counter in enumerate(self.counters) if counter != -1]

        # sort idx by counter
        sorted_available_idx_with_counter = sorted(available_idx_with_counter, key=lambda x: x[1])

        # extract sorted idx
        sorted_available_idx = [idx for idx, _ in sorted_available_idx_with_counter]

        counter_min = self.find_min_counter()
        size_current = self.compute_size(counter_min)
        current_config_size = self.get_current_config_size()
        
        while size_current >= current_config_size:
            self.increase_all_counters()
            counter_min = self.find_min_counter()
            size_current = self.compute_size(counter_min)
            if size_current == 1:
                break

        i = 0
        for key in sorted_available_idx:
            config_idx_to_delete.append(key)
            i = i + 1
            if i >= size_current:
                break

        logger.info("\tSelected deletion size: " + str(len(config_idx_to_delete)))
        return config_idx_to_delete

    def _test_done(self):
        all_decided = True
        for counter in self.counters:
            if counter != -1:
                all_decided = False
        if all_decided:
            logger.info("Iteration needs to stop because all elements are decided.")
            return True
        else:
            return False

    def map_idx_to_config(self, config_idx):
        new_config = []
        for idx, availability in enumerate(config_idx):
            if availability is True:
                new_config.append(self.original_config[idx])
        
        return new_config

    def _test_config(self, config_idx_to_delete, config_log_id):
        config_log_id = self._id_prefix + config_log_id
        logger.debug('\t[ %s ]: test...', self._pretty_config_id(config_log_id))

        # compute new config idx
        new_config_idx = copy.deepcopy(self.current_best_config_idx)
        for idx in config_idx_to_delete:
            new_config_idx[idx] = False

        new_config = self.map_idx_to_config(new_config_idx)
        outcome = self._test(new_config, config_log_id)

        logger.debug('\t[ %s ]: test = %r', self._pretty_config_id(config_log_id), outcome)

        return outcome

    @staticmethod
    def _pretty_config_id(config_id):
        return ' / '.join(str(i) for i in config_id)