#!/bin/bash

find . -type f -name '*.yml' -exec sed -i 's/paper_trade_enabled: true/paper_trade_enabled: false/g' {} +
