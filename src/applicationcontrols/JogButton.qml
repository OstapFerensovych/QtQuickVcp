/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 2.4
import Machinekit.Application 1.0

Button {
    id: root
    property alias core: jogAction.core
    property alias status: jogAction.status
    property alias command: jogAction.command
    property alias axis: jogAction.axis
    property alias distance: jogAction.distance
    property int direction: 1
    property double velocity: jogAction.settings.initialized ? jogAction.settings.values["axis" + axis]["jogVelocity"] : 0.0

    property bool useSafeJog: true
    property alias safeJogInterval: jogAction.safeJogInterval // ms
    property double safeJogDistanceFactor: 1.2 // Add 20% distance to send the next jog command just before it ends

    function _toggle(onOff) {
        if (jogAction.distance === 0.0) {
            // Infinite jog
            if (onOff) {
                jogAction.velocity = velocity * direction
                jogAction.trigger()
            } else {
                jogAction.velocity = 0
                jogAction.trigger()
            }
        } else if (onOff) {
            // Step jog
            jogAction.velocity = velocity * direction;
            jogAction.trigger()
        }
    }

    text: (direction === 1) ? "+" : "-"
    enabled: jogAction.enabled

    onPressedChanged: {
        if (!checkable)
            _toggle(pressed)
    }
    onCheckedChanged: {
        if (checkable)
            _toggle(checked)
    }

    JogAction {
        id: jogAction
        safeDistance: useSafeJog ? Math.abs(root.velocity) * safeJogInterval/1000 * safeJogDistanceFactor : 0.0
    }
}
