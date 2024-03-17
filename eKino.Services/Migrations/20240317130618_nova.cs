using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKino.Services.Migrations
{
    public partial class nova : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 1,
                column: "DateOfProjection",
                value: new DateTime(2024, 4, 15, 19, 4, 17, 160, DateTimeKind.Local).AddTicks(9730));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 2,
                column: "DateOfProjection",
                value: new DateTime(2024, 4, 12, 12, 45, 17, 160, DateTimeKind.Local).AddTicks(9980));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 3,
                column: "DateOfProjection",
                value: new DateTime(2024, 4, 14, 0, 35, 17, 161, DateTimeKind.Local).AddTicks(20));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 4,
                column: "DateOfProjection",
                value: new DateTime(2024, 4, 2, 10, 54, 17, 161, DateTimeKind.Local).AddTicks(70));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 1,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 2,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 3,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 4,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 5,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 6,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 7,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 8,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 9,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 10,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 11,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 12,
                column: "DateModified",
                value: new DateTime(2024, 3, 17, 0, 0, 0, 0, DateTimeKind.Local));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 1,
                column: "DateOfProjection",
                value: new DateTime(2024, 3, 21, 11, 53, 3, 563, DateTimeKind.Local).AddTicks(3700));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 2,
                column: "DateOfProjection",
                value: new DateTime(2024, 3, 15, 7, 7, 3, 563, DateTimeKind.Local).AddTicks(3880));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 3,
                column: "DateOfProjection",
                value: new DateTime(2024, 3, 18, 16, 5, 3, 563, DateTimeKind.Local).AddTicks(3910));

            migrationBuilder.UpdateData(
                table: "Projection",
                keyColumn: "ProjectionID",
                keyValue: 4,
                column: "DateOfProjection",
                value: new DateTime(2024, 3, 25, 22, 4, 3, 563, DateTimeKind.Local).AddTicks(3940));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 1,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 2,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 3,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 4,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 5,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 6,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 7,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 8,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 9,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 10,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 11,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));

            migrationBuilder.UpdateData(
                table: "UserRole",
                keyColumn: "UserRoleID",
                keyValue: 12,
                column: "DateModified",
                value: new DateTime(2024, 2, 27, 0, 0, 0, 0, DateTimeKind.Local));
        }
    }
}
