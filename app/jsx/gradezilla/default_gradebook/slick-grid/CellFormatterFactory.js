/*
 * Copyright (C) 2017 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import AssignmentCellFormatter from '../../../gradezilla/default_gradebook/slick-grid/formatters/AssignmentCellFormatter';
import AssignmentGroupCellFormatter from '../../../gradezilla/default_gradebook/slick-grid/formatters/AssignmentGroupCellFormatter';
import CustomColumnCellFormatter from '../../../gradezilla/default_gradebook/slick-grid/formatters/CustomColumnCellFormatter';
import StudentCellFormatter from '../../../gradezilla/default_gradebook/slick-grid/formatters/StudentCellFormatter';
import TotalGradeCellFormatter from '../../../gradezilla/default_gradebook/slick-grid/formatters/TotalGradeCellFormatter';

class CellFormatterFactory {
  constructor (gradebook) {
    this.formatters = {
      assignment: new AssignmentCellFormatter(gradebook),
      assignment_group: new AssignmentGroupCellFormatter(),
      custom_column: new CustomColumnCellFormatter(),
      student: new StudentCellFormatter(gradebook),
      total_grade: new TotalGradeCellFormatter(gradebook)
    };
  }

  getFormatter (column) {
    return (this.formatters[column.type] || {}).render;
  }
}

export default CellFormatterFactory;
