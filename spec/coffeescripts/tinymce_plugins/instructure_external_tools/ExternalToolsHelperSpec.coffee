#
# Copyright (C) 2015 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

define [
  'underscore'
  'tinymce_plugins/instructure_external_tools/ExternalToolsHelper',
  'jquery'
], (_, ExternalToolsHelper, $)->

  QUnit.module "ExternalToolsHelper:buttonConfig",
    setup: ->
      @buttonOpts = {
        name: "SomeName",
        id: "_SomeId"
      }
    teardown: ->

  test "makes a config as expected", ->
    config = ExternalToolsHelper.buttonConfig(@buttonOpts)
    equal config.title, "SomeName"
    equal config.cmd, 'instructureExternalButton_SomeId'
    equal config.classes, 'widget btn instructure_external_tool_button'

  test "modified string to avoid mce prefix", ->
    btn = _.extend({}, @buttonOpts, {canvas_icon_class: "foo-class"})
    config = ExternalToolsHelper.buttonConfig(btn)
    equal config.icon, "hack-to-avoid-mce-prefix foo-class"
    equal config.image, null

  test "defaults to image if no icon class", ->
    btn = _.extend({}, @buttonOpts, {icon_url: "example.com"})
    config = ExternalToolsHelper.buttonConfig(btn)
    equal config.icon, null
    equal config.image, "example.com"

  QUnit.module "ExternalToolsHelper:clumpedButtonMapping",
    setup: ->
      @clumpedButtons = [
        {id: "ID_1", name: "NAME_1", icon_url: "", canvas_icon_class: "foo"},
        {id: "ID_2", name: "NAME_2", icon_url: "", canvas_icon_class: null},
      ]
      @onClickHander = sinon.spy()
      @fakeEditor = sinon.spy()


    teardown: ->

  test "returns a hash of markup keys and attaches click handler to value", ->
    mapping = ExternalToolsHelper.clumpedButtonMapping(@clumpedButtons, @fakeEditor, @onClickHander)

    imageKey = _.chain(mapping).keys().select((k) -> k.match(/img/)).value()[0]
    iconKey = _.chain(mapping).keys().select((k) -> !k.match(/img/)).value()[0]

    imageTag = imageKey.split("&nbsp")[0]
    iconTag = iconKey.split("&nbsp")[0]

    equal $(imageTag).data("toolId"), "ID_2"
    equal $(iconTag).data("toolId"), "ID_1"

    ok @onClickHander.notCalled
    mapping[imageKey]()
    ok @onClickHander.called

  test "returns icon markup if canvas_icon_class in button", ->
    mapping = ExternalToolsHelper.clumpedButtonMapping(@clumpedButtons, () ->)
    iconKey = _.chain(mapping).keys().select((k) -> !k.match(/img/)).value()[0]
    iconTag = iconKey.split("&nbsp")[0]
    equal $(iconTag).prop("tagName"), "I"

  test "returns img markup if no canvas_icon_class", ->
    mapping = ExternalToolsHelper.clumpedButtonMapping(@clumpedButtons, () ->)
    imageKey = _.chain(mapping).keys().select((k) -> k.match(/img/)).value()[0]
    imageTag = imageKey.split("&nbsp")[0]
    equal $(imageTag).prop("tagName"), "IMG"

  QUnit.module "ExternalToolsHelper:attachClumpedDropdown",
    setup: ->
      @theSpy = sinon.spy()
      @fakeTarget = {
        dropdownList: @theSpy
      }
      @fakeButtons = "fb"
      @fakeEditor = {
        "on": () ->
      }
    teardown: ->

  test "calls dropdownList with buttons as options", ->
    fakeButtons = "fb"
    ExternalToolsHelper.attachClumpedDropdown(@fakeTarget, fakeButtons, @fakeEditor)

    ok @theSpy.calledWith(
      {"options": fakeButtons}
    )

  QUnit.module 'contentItemDialog event handlers',
    setup: ->
      @dialogHtml = """
        <div id="main-container">
          <div class="ui-dialog ui-widget ui-widget-content ui-corner-all ui-draggable ui-resizable" tabindex="-1" style="outline: 0px; z-index: 1002; position: absolute; height: auto; width: 800px; top: 184px; left: 280px; display: block;" aria-hidden="false">
           <div class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix"><span id="ui-id-9" class="ui-dialog-title" role="heading">My LTI Editor Button</span><button class="ui-dialog-titlebar-close ui-corner-all"><span class="ui-icon ui-icon-closethick">close</span></button></div>
             <div id="external_tool_button_dialog" style="padding: 0px; overflow-y: hidden; width: auto; min-height: 0px; height: 340px;" class="ui-dialog-content ui-widget-content" scrolltop="0" scrollleft="0">
                <div class="teaser" style="width: 800px; margin-bottom: 10px; display: none;"></div>
                <div class="before_external_content_info_alert screenreader-only" tabindex="0">
                   <div class="ic-flash-info">
                      <div class="ic-flash__icon" aria-hidden="true"><i class="icon-info"></i></div>
                      The following content is partner provided
                   </div>
                </div>
                <form id="external_tool_button_form" method="POST" target="external_tool_launch" action="/courses/17/external_tools/43/resource_selection"><input type="hidden" name="editor" value="1"><input id="selection_input" type="hidden" name="selection" value=""><input id="editor_contents_input" type="hidden" name="editor_contents" value=""></form>
                <iframe name="external_tool_launch" src="/images/ajax-loader-medium-444.gif" id="external_tool_button_frame" style="width: 800px; height: 340px; border: 0px;" borderstyle="0" tabindex="0"></iframe>
                <div class="after_external_content_info_alert screenreader-only" tabindex="0">
                   <div class="ic-flash-info">
                      <div class="ic-flash__icon" aria-hidden="true"><i class="icon-info"></i></div>
                      The preceding content is partner provided
                   </div>
                </div>
             </div>
             <div class="ui-resizable-handle ui-resizable-n" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-e" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-s" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-w" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se ui-icon-grip-diagonal-se" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-sw" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-ne" style="z-index: 1000;"></div>
             <div class="ui-resizable-handle ui-resizable-nw" style="z-index: 1000;"></div>
          </div>
        </div>
      """
    teardown: ->
      $("#fixtures").empty()
      ENV = undefined

  test 'unloads the dialog on close', ->
    $dialog = $(@dialogHtml)
    $('#fixtures').append($dialog)
    dialog = $('.ui-dialog').dialog()
    plugin = { beforeUnloadHandler: (x) => {x} }
    ExternalToolsHelper.contentItemDialogClose(dialog, plugin)
    equal($('.ui-dialog').length, 0)

  test 'populates the editor contents input', ->
    $dialog = $(@dialogHtml)
    $('#fixtures').append($dialog)
    button = { id: 1 }
    ed = {
      getContent: () => 'All editor contents.',
      selection: { getContent: () => 'itor conte' }
    }
    form = $('#external_tool_button_form')
    @stub(form, 'submit').returns({status: 200, data: {}})
    ExternalToolsHelper.contentItemDialogOpen(button, ed, 'course_1', form)
    equal($('#editor_contents_input').val(), ed.getContent())

  test 'populates the editor selection input', ->
    $dialog = $(@dialogHtml)
    $('#fixtures').append($dialog)
    button = { id: 1 }
    ed = {
      getContent: () => 'All editor contents.',
      selection: { getContent: () => 'itor conte' }
    }
    form = $('#external_tool_button_form')
    @stub(form, 'submit',).returns({status: 200, data: {}})
    ExternalToolsHelper.contentItemDialogOpen(button, ed, 'course_1', form)
    equal($('#selection_input').val(), ed.selection.getContent())
