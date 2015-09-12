#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright (c) 2015 Andy Lindeman.

include_recipe "postfix::install"
include_recipe "postfix::srs"
include_recipe "postfix::configure"
include_recipe "postfix::sasl"
include_recipe "postfix::service"
