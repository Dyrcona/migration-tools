-- Copyright 2015, Equinox Software, Inc.
-- Author: Galen Charlton <gmc@esilibrary.com>
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

\set ou_to_del ''''EXAMPLE''''
\set ECHO all
\timing

BEGIN;

UPDATE asset.copy SET editor = 1 WHERE editor IN
(SELECT id FROM actor.usr WHERE home_ou IN (SELECT (actor.org_unit_descendants(id)).id from actor.org_unit where shortname = :ou_to_del));
UPDATE asset.call_number SET editor = 1 WHERE editor IN
(SELECT id FROM actor.usr WHERE home_ou IN (SELECT (actor.org_unit_descendants(id)).id from actor.org_unit where shortname = :ou_to_del));

UPDATE asset.copy SET creator = 1 WHERE creator IN
(SELECT id FROM actor.usr WHERE home_ou IN (SELECT (actor.org_unit_descendants(id)).id from actor.org_unit where shortname = :ou_to_del));
UPDATE asset.call_number SET creator = 1 WHERE creator IN
(SELECT id FROM actor.usr WHERE home_ou IN (SELECT (actor.org_unit_descendants(id)).id from actor.org_unit where shortname = :ou_to_del));

UPDATE biblio.record_entry SET creator = 1 WHERE creator IN
(SELECT id FROM actor.usr WHERE home_ou IN (SELECT (actor.org_unit_descendants(id)).id from actor.org_unit where shortname = :ou_to_del));
UPDATE biblio.record_entry SET editor = 1 WHERE editor IN
(SELECT id FROM actor.usr WHERE home_ou IN (SELECT (actor.org_unit_descendants(id)).id from actor.org_unit where shortname = :ou_to_del));

COMMIT;

