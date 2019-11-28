#!/bin/bash

find . -type f -name '*.yml' -exec sed -i 's/paper_trade_enabled: false/paper_trade_enabled: true/g' {} +
