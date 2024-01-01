# Copyright (c) 2016-2020 Renata Hodovan, Akos Kiss.
#
# Licensed under the BSD 3-Clause License
# <LICENSE.rst or https://opensource.org/licenses/BSD-3-Clause>.
# This file may not be copied, modified, or distributed except
# according to those terms.

import logging
import random
import ast
import collections
import time
import traceback
from .outcome_cache import OutcomeCache, ContentCache
import copy
from datetime import datetime
logger = logging.getLogger(__name__)


class AbstractProbDD(object):

    # Test outcomes.
    PASS = 'PASS'
    FAIL = 'FAIL'

    def __init__(self, test, split, cache=None, id_prefix=(), other_config={}):
        self._test = test
        self._split = split
        self._id_prefix = id_prefix
        self.p = collections.OrderedDict()
        self.init_probability = other_config["init_probability"]
        self.threshold = 0.8
        self.passconfig = []
        self.previous_position = 0

    def __call__(self, config):
        """
        Return a 1-minimal failing subset of the initial configuration.
        :param config: The initial configuration that will be reduced.
        :return: 1-minimal failing configuration.
        """
        
        tstart = time.time()
        self.original_config = config[:]
        self.partition_size = max(len(self.original_config) / 2, 1)
        self.index = 0
        self.next_size = True
        for c in config:
            self.p[c] = self.init_probability 
        
        self.p_backup = copy.deepcopy(self.p)
        run = 0
        self.passconfig = config
        while not self._test_done():
            logger.info('Run #%d', run)
            logger.info('\tConfig size: %d', len(self.passconfig))
            
            # select a subsequence for testing
            logger.info("%s: marker1" % datetime.now().strftime("%H:%M:%S"))
            deleteconfig = self.sample()

            logger.info("%s: marker2" % datetime.now().strftime("%H:%M:%S"))
            config2test = self._minus(self.passconfig, deleteconfig)
            # self.printIdx(deleteconfig, "Try deleting")
            config_id = ('r%d' % run, )
            if(len(config2test) == len(self.passconfig)):
                continue

            logger.info("%s: marker3" % datetime.now().strftime("%H:%M:%S"))
            outcome = self._test_config(config2test, config_id)
            # FAIL means current variant cannot satisify the property
            logger.info("%s: marker4" % datetime.now().strftime("%H:%M:%S"))
            if outcome == self.FAIL:
                # logger.info("test failed\n")
                self.old_p = copy.deepcopy(self.p)
                logger.info("%s: marker5" % datetime.now().strftime("%H:%M:%S"))
                for key in self.old_p.keys():
                    if key not in config2test and self.old_p[key] != 0 and self.old_p[key] != 1:
                        delta = (self.computeRatio(deleteconfig, self.old_p) - 1) * self.old_p[key]
                        self.p[key] = self.p[key] + delta
                logger.info("%s: marker6" % datetime.now().strftime("%H:%M:%S"))
                logger.info("%s: marker7" % datetime.now().strftime("%H:%M:%S"))
                if len(deleteconfig) == 1:
                    #logger.info(str(deleteconfig[0]) + " must preserve\n")
                    self.p[deleteconfig[0]] = 1
            else:
                logger.info("%s: marker8" % datetime.now().strftime("%H:%M:%S"))
                # logger.info("test passed\n")
                for key in self.p.keys():
                    if key not in config2test:
                        self.p[key] = 0
                logger.info("%s: marker9" % datetime.now().strftime("%H:%M:%S"))
                deleteconfig = self._minus(self.passconfig, config2test)
                self._process(deleteconfig,self.PASS)
                # print successfully deleted idx
                # self.printIdx(deleteconfig, "Deleted")
                logger.info("%s: marker10" % datetime.now().strftime("%H:%M:%S"))
                self.passconfig = config2test
                continue
            
            run += 1

        logger.info("Final size: %d/%d" % (len(self.passconfig), len(config)))
        logger.info("Execution time at this level: %f s" % (time.time() - tstart))
        return self.passconfig

    def printIdx(self, deleteconfig, info):
        indices = []
        for item in deleteconfig:
            idx = self.original_config.index(item)
            indices.append(idx)
        indices.sort()
        logger.info("\t%s: %r" % (info, indices))

    def computeRatio(self, deleteconfig, p):
        res = 0
        tmplog = 1
        for delc in deleteconfig:
            if p[delc] > 0 and p[delc] < 1:
                tmplog *= (1 - p[delc])
        if (tmplog == 1):
            res = 1
        else:
            res = 1 / (1 - tmplog)
        return res

    def _processElementToPreserve(toBePreserve):
        raise NotImplementedError()

    def _process(self, config, outcome):
        raise NotImplementedError()

    def f(self,x):
        return min(x,1)

    def sample(self):
        config2test = []
        self.p = collections.OrderedDict(sorted(self.p.items(), key=lambda item:item[1]))
        k = 0
        current_gain = 1
        last_gain = 0
        keylist = list(self.p.keys())
        i = 0
        while i < len(self.p):
            # logger.info("%s: marker11" % datetime.now().strftime("%H:%M:%S"))
            logger.info("i=%d" % i)
            # if prob == 0, skip the element
            if self.p[keylist[i]] == 0 :
                k = k + 1
                i = i + 1
                continue
            # if prob >= 1, stop
            if not self.p[keylist[i]] < 1 :
                break
            # compute gain value under corrent range [k, i)
            for j in range(k,i):
                current_gain *= (1 - self.p[keylist[i]])
            current_gain *= (i - k + 1)
            # logger.info("%s: marker12" % datetime.now().strftime("%H:%M:%S"))
            # logger.info("current gain=%s" % current_gain)

            # find out the range with max gain and stop
            if current_gain < last_gain:
                break
            last_gain = current_gain
            current_gain = 1
            i = i + 1
        while i > k:
            i = i - 1
            config2test.append(keylist[i])
        logger.info("\tSelected deletion size: " + str(len(config2test)))
        return config2test

    def sample_counter(self):
        config2test = []
        self.p = collections.OrderedDict(sorted(self.p.items(), key=lambda item:item[1]))
        i = 0
        k = 0
        current_sum = 0
        keylist = self.p.keys()
        while i < len(self.p):
            # if prob == 0, skip the element
            if self.p[keylist[i]] == 0 :
                k = k + 1
                i = i + 1
                continue
            # if prob >= 1, stop
            if not self.p[keylist[i]] < 1 :
                break
            current_sum += self.p[keylist[i]]

            # find out the range with max gain and stop
            if current_sum > 1:
                break
            i = i + 1
        while i > k:
            i = i - 1
            config2test.append(keylist[i])
        logger.info("\tSelected deletion size: " + str(len(config2test)))
        return config2test

    def sample_dd(self):
        config2test = []
        # at the start of a partition size: backup p and sort
        if (self.next_size):
            self.p = collections.OrderedDict(sorted(self.p.items(), key=lambda item:item[1]))
            self.p_backup = copy.deepcopy(self.p)
            self.next_size = False

        keylist = [key for key in self.p.keys() if self.p[key] > 0]
        self.current_size = len(keylist)
        end_index = min(self.index + self.partition_size, self.current_size)
        for i in range(self.index, end_index):
            config2test.append(keylist[i])
        self.index = self.index + self.partition_size
        
        # if reach the end, do smaller partition size
        if (self.index >= self.current_size):
            self.index = 0
            self.partition_size = self.partition_size / 2
            self.next_size = True

        logger.info("\tSelected deletion size: " + str(len(config2test)))
        return config2test

    def sample_sequentially(self):
        config2test = []
        current_idx = self.previous_position % len(self.p)
        idx_list = []
        p_list = []
        current_gain = 1
        last_gain = 0
        keylist = self.p.keys()
        while current_idx < len(self.p):
            if self.p[keylist[current_idx]] > 0 and self.p[keylist[current_idx]] < 1:
                idx_list.append(keylist[current_idx])
                p_list.append(self.p[keylist[current_idx]])
            else:
                current_idx = current_idx + 1
                continue

            for j in range(len(idx_list)):
                current_gain *= (1 - p_list[j])
            current_gain *= len(idx_list)

            # find out the range with max gain and stop
            if current_gain < last_gain:
                idx_list.pop()
                p_list.pop()
                break
            last_gain = current_gain
            current_gain = 1
            current_idx = current_idx + 1

        self.previous_position = current_idx
        config2test = idx_list

        logger.info("\tSelected deletion size: " + str(len(config2test)))
        return config2test

    def _test_done(self):
       
        alldecided = True
        tmp = list(set(self.p.values()))
        for value in tmp:
            if value > 0 and value < 1:
                alldecided = False
        if alldecided:
            logger.info("Iteration needs to stop because all elements are decided.")
            return True
        for key in self.p.keys():
            if self.f(self.p[key])<self.threshold:
                return False
        logger.info("Iteration needs to stop because of convergence.")
        return True

    def _test_config(self, config, config_id):
        """
        Test a single configuration and save the result in cache.
        :param config: The current configuration to test.
        :param config_id: Unique ID that will be used to save tests to easily
            identifiable directories.
        :return: PASS or FAIL
        """
        config_id = self._id_prefix + config_id

        logger.debug('\t[ %s ]: test...', self._pretty_config_id(config_id))
        outcome = self._test(config, config_id)
        logger.debug('\t[ %s ]: test = %r', self._pretty_config_id(config_id), outcome)

        return outcome

    @staticmethod
    def _pretty_config_id(config_id):
        """
        Create beautified identifier for the current task from the argument.
        The argument is typically a tuple in the form of ('rN', 'DM'), where N
        is the index of the current iteration, D is direction of reduce (either
        s(ubset) or c(omplement)), and M is the index of the current test in the
        iteration. Alternatively, argument can also be in the form of
        (rN, 'assert') for double checking the input at the start of an
        iteration.
        :param config_id: Config ID tuple.
        :return: Concatenating the arguments with slashes, e.g., "rN / DM".
        """
        return ' / '.join(str(i) for i in config_id)

    @staticmethod
    def _minus(c1, c2):
        """
        Return a list of all elements of C1 that are not in C2.
        """
        c2 = set(c2)
        return [c for c in c1 if c not in c2]