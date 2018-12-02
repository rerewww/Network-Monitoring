/**
 * Created by son on 2018-11-12.
 */
var packets = {
    removePackets: function () {
        var elemPackets = document.getElementById('packets').children[0];
        var LIMIT_CHILD_LENGTH = 100;
        if (elemPackets.childElementCount < LIMIT_CHILD_LENGTH) {
            return;
        }
        for (var i = 0; i < LIMIT_CHILD_LENGTH; i++) {
            elemPackets.removeChild(elemPackets.firstChild);
        }
    },

    showPackets : function (result) {
        var onclick = function() {
            if (window.event.target.parentElement.style.backgroundColor === 'silver') {
                window.event.target.parentElement.className = "";
                viewStyle.setStyle(window.event.target.parentElement, 'background-color', window.event.target.parentElement.beforeColor);
            } else {
                window.event.target.parentElement.className = "commit";
                window.event.target.parentElement.beforeColor = window.event.target.parentElement.style.backgroundColor;
                viewStyle.setStyle(window.event.target.parentElement, 'background-color', 'silver');
            }

            if (document.getElementById('hexDumpInfo').childElementCount > 5) {
                document.getElementById('hexDumpInfo').removeChild(document.getElementById('hexDumpInfo').children[1]);
            }

            var ethernetContents = document.getElementById('ethernetContents');
            var ipContents = document.getElementById('ipContents');
            var tcpContents = document.getElementById('tcpContents');
            var dumpContents = document.getElementById('dumpContents');

            this._detailsRemoveChild([ethernetContents, ipContents, tcpContents, dumpContents]);

            var detailInfos = JSON.parse(window.event.target.parentElement.getAttribute('value'));
            renderer.ethernet.render(detailInfos.ethernetModel);
            renderer.ip.render(detailInfos.ipModel);
            renderer.tcp.render(detailInfos.tcpModel);
            renderer.dump.render(detailInfos.dump);

            viewStyle.setStyle(ethernetContents, 'display', 'block');
            viewStyle.setStyle(ipContents, 'display', 'block');
            viewStyle.setStyle(tcpContents, 'display', 'block');
            viewStyle.setStyle(dumpContents, 'display', 'block');
        }.bind(this);

        renderer.packet.render(result, onclick);
    },

    _detailsRemoveChild: function(detailContentElems) {
        detailContentElems.forEach(function (detailContentElem) {
            var len = detailContentElem.childElementCount;
            for (var i = 0; i < len; i++) {
                detailContentElem.removeChild(detailContentElem.firstChild);
            }
        });
    },

    startDetectPackets: function (id) {
        if (!id) {
            if (!$('input[id=cpuCheck]').is(":checked")) {
                $('input[id=cpuCheck]').trigger('click');
            }
            if (!$('input[id=memoryCheck]').is(":checked")) {
                $('input[id=memoryCheck]').trigger('click');
            }
            if (!$('input[id=graphCheck]').is(":checked")) {
                $('input[id=graphCheck]').trigger('click');
            }
            if (!$('input[id=packetsCheck]').is(":checked")) {
                $('input[id=packetsCheck]').trigger('click');
            }
            if (!$('input[id=procName]').is(":checked")) {
                $('input[id=procName]').trigger('click');
            }
        }

        setting.clearIdMap.detectCheck = setInterval(function () {
            $.ajax({
                url: '/network/detect',
                type:'GET',
                async: true,
                data: { isProcName: $('input[id=procName]').is(":checked") },
                dataType: 'json',
                success: function(response) {
                    if (response === null || response === undefined) {
                        console.warn('detecte packets is empty');
                        return;
                    }
                    packets.removePackets();
                    if ($('input[id=packetsCheck]').is(":checked")) {
                        packets.showPackets(response.data);
                    }

                    if ($('input[id=procName]').is(":checked")) {
                        chart.drawPieChart(response.most);
                    }

                    domControl.moveScroll();

                    if ($('input[id=graphCheck]').is(":checked")) {
                        chart.drawPacketChart(response.size);
                    }
                },
                error: function(response) {
                    console.warn('error occurred: ', response.responseText);
                }
            });
        }.bind(this), 10000);
    },

    download: function () {
        var downloadElem = document.getElementById('download');
        downloadElem.value = this._getDownloadText(document.getElementById('hexDumpInfo'));
    },

    commit: function () {
        var commands = [];
        var tr = document.getElementsByTagName('tr');
        var len = tr.length;
        for (var i = 0; i < len; i++) {
            if (tr[i].className !== 'commit') {
                continue;
            }
            commands.push({
                'localAddress': tr[i].children[1].textContent,
                'remoteAddress': tr[i].children[2].textContent,
                'protocol': tr[i].children[3].textContent,
                'info': tr[i].children[4].textContent
            });
        }
        var downloadElem = document.getElementById('commit');
        downloadElem.value = commands;
    },

    _getDownloadText: function(elem) {
        var contents = '';
        var i = 0;
        for(; i < elem.childElementCount; i++) {
            var children = elem.children[i];
            if (children.childElementCount > 0) {
                contents += this._getDownloadText(children);
            } else {
                if (children.tagName === 'SUMMARY') {
                    contents = '\n' + contents;
                }
                contents += children.outerText;
                contents += '\n';
            }
        }
        return contents;
    }
};